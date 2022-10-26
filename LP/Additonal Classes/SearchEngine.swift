//
//  SearchEngine.swift
//  LP
//
//  Created by Anton Kolesnikov on 15.10.2022.
//

import Foundation

struct SearchEngine {
    /// Creates a new instance for testing matches against `searchString`.
    public init(searchString: String) {
        // Split `searchString` into tokens by whitespace and sort them by decreasing length
        searchTokens = searchString.split(whereSeparator: { $0.isWhitespace }).sorted { $0.count > $1.count }
    }

    /// Check if `candidateString` matches `searchString`.
    func matches(_ candidateString: UserProduct) -> Bool {
        // If there are no search tokens, everything matches
        guard !searchTokens.isEmpty else { return true }

        let paths = [\UserProduct.product?.name, \UserProduct.product?.brand.name, \UserProduct.product?.details.color, \UserProduct.product?.details.gender, \UserProduct.product?.details.season, \UserProduct.product?.details.type, \UserProduct.product?.details.material.convertToString]
        
        // Split `candidateString` into tokens by whitespace
        var candidateStringTokens = paths.map { (candidateString[keyPath:$0] ?? "") }
        
        // Iterate over each search token
        for searchToken in searchTokens {
            // We haven't matched this search token yet
            var matchedSearchToken = false
            // Iterate over each candidate string token
            for (candidateStringTokenIndex, candidateStringToken) in candidateStringTokens.enumerated() {
                // Does `candidateStringToken` start with `searchToken`?
                if let range = candidateStringToken.range(of: searchToken, options: [.caseInsensitive, .diacriticInsensitive]),
                   range.lowerBound == candidateStringToken.startIndex {
                    matchedSearchToken = true
                    candidateStringTokens.remove(at: candidateStringTokenIndex)
                    break
                }
            }
            // If we failed to match `searchToken` against the candidate string tokens, there is no match
            guard matchedSearchToken else { return false }
        }
        // If we match every `searchToken` against the candidate string tokens, `candidateString` is a match
        return true
    }

    private(set) var searchTokens: [String.SubSequence]
}

extension Dictionary where Key: StringProtocol, Value: StringProtocol {
    var convertToString: String {
        self.map { "\($1)" }.joined(separator: " ")
    }
}
