// Copyright (c) 2018 Token Browser, Inc
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import Foundation

extension UITextField {

    /// - Returns: true if there is text of length greater than zero, false if not
    var hasText: Bool {
        guard let text = self.text else { return false }

        return !text.isEmpty
    }

    /// - Returns: text if there is any or emty string
    var currentOrEmptyText: String {
        return String.contentsOrEmpty(for: text)
    }
}
