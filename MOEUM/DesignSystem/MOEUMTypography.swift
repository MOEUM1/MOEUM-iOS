import SwiftUI

enum MOEUMTypography {
    // Figma specifies absolute type sizes. Avoid Dynamic Type scaling here so the
    // iPhone simulator matches the 393pt design frames pixel-for-pixel.
    static let h1Bold = Font.custom("Pretendard-Bold", size: 24)
    static let h1Medium = Font.custom("Pretendard-Medium", size: 24)

    static let h2Bold = Font.custom("Pretendard-Bold", size: 20)
    static let h2Medium = Font.custom("Pretendard-Medium", size: 20)
    static let h2Handwriting = Font.custom("OwnglyphEuiyeonChae", size: 36)

    static let bodyBold = Font.custom("Pretendard-Bold", size: 18)
    static let bodyMedium = Font.custom("Pretendard-Medium", size: 18)

    static let buttonBold = Font.custom("Pretendard-Bold", size: 16)
    static let buttonMedium = Font.custom("Pretendard-Medium", size: 16)

    static let buttonSmallBold = Font.custom("Pretendard-Bold", size: 12)
    static let buttonSmallSemiBold = Font.custom("Pretendard-SemiBold", size: 12)
    static let buttonSmallMedium = Font.custom("Pretendard-Medium", size: 12)

    static let captionBold = Font.custom("Pretendard-Bold", size: 14)
    static let captionMedium = Font.custom("Pretendard-Medium", size: 14)
}
