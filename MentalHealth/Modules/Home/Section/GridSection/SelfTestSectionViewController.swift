//
//  SelfTestSectionViewController.swift
//  MentalHealth
//
//  Created by JungpyoHong on 11/5/25.
//

public final class SelfTestSectionViewController: BaseSectionViewController {
    let tileRegistry = GridTileRegistry()

    public override func viewDidLoad() {
        tileRegistry.register(
            tile: GridTile(
                title: String.localized(.aiCounselorHome),
                imageName: "Icon/counselor",
                onTap: { parent in
                    parent.navigate(to: MyDiaryViewController.self,
                                    storyboardName: "MyDiaryFlow",
                                    hidesBottomBarWhenPushed: true)
                }
            ),
            for: .aiCounselor
        )
    }
}
