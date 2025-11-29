//
//  MeditationViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 5/13/25.
//

import UIKit
import AVFoundation
import Lottie
final class MeditationViewController: BaseViewController {
    
    private lazy var lottieView = LottieAnimationView(name: MeditationResources.animation.rawValue, bundle: .mentalHealthBundle)
    private var audioPlayer: AVAudioPlayer?
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var voiceTimer: Timer?
    private var endTimer: Timer?
    private var voiceCueTimer: Timer?
    private var remainingVoiceCues = 36
    private var isBreathingIn = true
    
    private lazy var titleLabel: SoliULabel = {
        let label = SoliULabel()
        label.text = "🌿 Breathe in, breathe out."
        label.textColor = SoliUColor.soliuBlack
        label.font = SoliUFont.bold20
        label.textAlignment = .center
        return label
    }()

    private lazy var startButton: SoliUButton = {
        let button = SoliUButton(type: .system)
        button.setTitle("🎧 Begin Your 3-Minute Calm", for: .normal)
        button.titleLabel?.font = SoliUFont.bold14
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = SoliUSpacing.space16
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientBackground()
        setCustomBackNavigationButton()
        setupUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioPlayer?.stop()
        voiceTimer?.invalidate()
        voiceCueTimer?.invalidate()
        lottieView.stop()
    }

    func applyGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }

    private func setupUI() {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 32
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)

        [titleLabel, lottieView, startButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 300),
            cardView.heightAnchor.constraint(equalToConstant: 360),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            lottieView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            lottieView.widthAnchor.constraint(equalToConstant: 120),
            lottieView.heightAnchor.constraint(equalTo: lottieView.widthAnchor),

            startButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24),
            startButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 220),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        startButton.addTarget(self, action: #selector(startMeditation), for: .touchUpInside)
    }

    @objc private func startMeditation() {
        lottieView.loopMode = .autoReverse
        lottieView.play()
        
        playBGM()
        startVoiceCueLoop()
        scheduleEndTimer()
        startButton.isEnabled = false
        startButton.alpha = 0.5
    }

    private func playBGM() {
        guard let url = Bundle.mentalHealthBundle.url(forResource: MeditationResources.audio.rawValue, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Error playing BGM: \(error.localizedDescription)")
        }
    }

    private func startVoiceCueLoop() {
        remainingVoiceCues = 36
        isBreathingIn = true
        speakCue()

        voiceCueTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            guard self.remainingVoiceCues > 0 else {
                self.voiceCueTimer?.invalidate()
                return
            }
            self.speakCue()
        }
    }

    private func speakCue() {
        let text = isBreathingIn ? String.localized(.breatheIn) : String.localized(.breatheOut)
        let utterance = AVSpeechUtterance(string: text)

        utterance.voice = AVSpeechSynthesisVoice(language: SoliULanguageManager.shared.currentLanguageWithFullName)
        utterance.rate = 0.45
        speechSynthesizer.speak(utterance)

        isBreathingIn.toggle()
        remainingVoiceCues -= 1
    }

    private func scheduleEndTimer() {
        endTimer = Timer.scheduledTimer(withTimeInterval: 180, repeats: false) { _ in
            self.finishMeditation()
        }
    }

    private func finishMeditation() {
        voiceTimer?.invalidate()
        audioPlayer?.stop()
        lottieView.stop()

        let alert = UIAlertController(title: "Good job 🌿", message: "You’ve completed your 5-minute meditation.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .localized(.ok), style: .default))
        present(alert, animated: true)

        startButton.isEnabled = true
        startButton.alpha = 1
    }
}
