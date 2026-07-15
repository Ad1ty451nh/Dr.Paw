//
//  TopRoundedRectangle.swift
//  Dr.Paw
//
//  Created by Adityasinh on 08/07/26.
//
import SwiftUI

struct TopRoundedRectangle: Shape {

    var radius: CGFloat = 45

    func path(in rect: CGRect) -> Path {

        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: radius))

        path.addQuadCurve(
            to: CGPoint(x: radius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )

        path.addLine(to: CGPoint(x: rect.width - radius, y: 0))

        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: radius),
            control: CGPoint(x: rect.width, y: 0)
        )

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        path.closeSubpath()

        return path
    }
}
