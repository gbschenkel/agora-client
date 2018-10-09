import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

ListView {
    delegate: Frame {
        id: frame
        width: parent.width
        height: speakerRow.height + 2*padding
        clip: true
        anchors { left: parent.left; right: parent.right; rightMargin: internal.viewMargin; leftMargin: internal.viewMargin }
        Image {
            id: speakerRow
            width: parent.width
            source: modelData.drawer_url
            fillMode: Image.PreserveAspectFit
        }
        ItemDelegate {
            anchors { fill: parent; margins: -11 }
            onClicked: {
                internal.conferenceId = index+1
//                titleLabel.text = modelData.acronym
//                parentItem.state = "waitingForSignIn"
                parentItem.state = Qt.binding(function() { return (userModel.json !== undefined && userModel.json.login !== undefined) ? "signedIn":"waitingForSignIn" })
            }
        }
    }
}
