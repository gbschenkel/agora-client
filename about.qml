import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Flickable {
    contentHeight: column.height

    Column {
        id: column

        width: parent.width
        padding: internal.viewMargin
        spacing: 15
        Image {
            width: appWindow.width/3
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/agora-icon.png"
        }
        Label {
            text: "<br/><b>Ágora Mobile v0.2.1</b><br/>Este aplicativo foi desenvolvido em Qt pela <a href=\"http://qmob.solutions\" target=\"_blank\">qmob solutions</a>."
            font.bold: false
            horizontalAlignment: Label.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
            onLinkActivated: Qt.openUrlExternally(link)
        }
        Label {
            text: "<b>Principais Funcionalidades</b><br/>Suporte a múltiplas conferências<br/>Login pelo número de inscrição<br/>Visualização de atividades por dia<br/>Visualização de atividades por palestrante<br/>Visualização de atividades por tag<br/>Avaliação de palestras"
            font.bold: false
            horizontalAlignment: Label.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}
