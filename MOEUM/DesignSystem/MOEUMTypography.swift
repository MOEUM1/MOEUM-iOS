import SwiftUI

enum MOEUMTypography {
    static let h1Bold = Font.custom("Pretendard-Bold", size: 24, relativeTo: .title2)
    static let h1Medium = Font.custom("Pretendard-Medium", size: 24, relativeTo: .title2)

    static let h2Bold = Font.custom("Pretendard-Bold", size: 20, relativeTo: .title3)
    static let h2Medium = Font.custom("Pretendard-Medium", size: 20, relativeTo: .title3)
    static let h2Handwriting = Font.custom("OwnglyphEuiyeonChae", size: 36, relativeTo: .title2)

    static let bodyBold = Font.custom("Pretendard-Bold", size: 18, relativeTo: .body)
    static let bodyMedium = Font.custom("Pretendard-Medium", size: 18, relativeTo: .body)

    static let buttonBold = Font.custom("Pretendard-Bold", size: 16, relativeTo: .callout)
    static let buttonMedium = Font.custom("Pretendard-Medium", size: 16, relativeTo: .callout)

    static let buttonSmallBold = Font.custom("Pretendard-Bold", size: 12, relativeTo: .caption)
    static let buttonSmallSemiBold = Font.custom("Pretendard-SemiBold", size: 12, relativeTo: .caption)
    static let buttonSmallMedium = Font.custom("Pretendard-Medium", size: 12, relativeTo: .caption)

    static let captionBold = Font.custom("Pretendard-Bold", size: 14, relativeTo: .caption)
    static let captionMedium = Font.custom("Pretendard-Medium", size: 14, relativeTo: .caption)
}
