import QtQuick 2.11
import QtQuick.Controls 2.4

StackView {
    property alias model: listView.model
    property alias delegate: listView.delegate

    clip: true

    id: stackView

    initialItem: ListView {
        id: listView
        spacing: internal.viewMargin
    }
}
