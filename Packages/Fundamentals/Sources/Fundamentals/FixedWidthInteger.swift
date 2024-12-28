//
//  FixedWidthInteger.swift
//
//
//  Created by Luca Archidiacono on 30.04.2024.
//

import Foundation

public extension FixedWidthInteger {
    /// Saturating integer multiplication. Computes `self * rhs`, saturating at the numeric bounds
    /// instead of overflowing.
    func saturatingMultiplication(_ rhs: Self) -> Self {
        let (partialValue, isOverflow) = multipliedReportingOverflow(by: rhs)

        if isOverflow {
            return signum() == rhs.signum() ? .max : .min
        } else {
            return partialValue
        }
    }

    /// Saturating integer addition. Computes `self + rhs`, saturating at the numeric bounds
    /// instead of overflowing.
    func saturatingAddition(_ rhs: Self) -> Self {
        let (partialValue, isOverflow) = addingReportingOverflow(rhs)

        if isOverflow {
            return partialValue.signum() >= 0 ? .min : .max
        } else {
            return partialValue
        }
    }

    /// Saturating integer subtraction. Computes `self - rhs`, saturating at the numeric bounds
    /// instead of overflowing.
    func saturatingSubtraction(_ rhs: Self) -> Self {
        let (partialValue, isOverflow) = subtractingReportingOverflow(rhs)

        if isOverflow {
            return partialValue.signum() >= 0 ? .min : .max
        } else {
            return partialValue
        }
    }

    /// Saturating integer exponentiation. Computes `self ** exp`, saturating at the numeric
    /// bounds instead of overflowing.
    func saturatingPow(_ exp: UInt32) -> Self {
        let result = pow(Double(self), Double(exp))

        if result.isFinite {
            if result <= Double(Self.min) {
                return .min
            } else if result >= Double(Self.max) {
                return .max
            } else {
                return Self(result)
            }
        } else {
            return result.sign == .minus ? Self.min : Self.max
        }
    }
}
