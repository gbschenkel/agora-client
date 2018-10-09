import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Flickable {
    id: flickable

    property var model

    contentHeight: column.height

    Column {
        id: column

        width: parent.width
        padding: internal.viewMargin
        spacing: 15
        MyGroupBox {
            title: "Resumo"
            Label {
                text: model.abstract
                font.bold: false
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
        MyGroupBox {
            title: "Biografia do" + ((model.speakers.length > 1) ? "s":"") + " Palestrante" + ((model.speakers.length > 1) ? "s":"")
            Column {
                width: parent.width
                spacing: 10
                Repeater {
                    model: flickable.model.speakers
                    Label {
                        text: "<b>" + modelData.name + "</b> - " + ((modelData.resume !== "") ? modelData.resume:"Não informada")
                        font.bold: false
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
        MyGroupBox {
            title: "Tipo da Atividade"
            RowLayout {
                Label { text: model.activity_type.icon; font.bold: false; font { family: fontAwesome.name; pointSize: 12 } }
                Label { text: model.activity_type.name; font.bold: false }
            }
        }
        MyGroupBox {
            title: "Tags da Atividade"
            GridLayout {
                rows: flickable.model.activity_tags.length
                columns: 2
                flow: GridLayout.TopToBottom
                Repeater {
                    model: flickable.model.activity_tags
                    Label { text: modelData.icon; Layout.preferredWidth: internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; font.bold: false; font { family: fontAwesome.name; pointSize: 12 } }
                }
                Repeater {
                    model: flickable.model.activity_tags
                    Label { text: modelData.name; font.bold: false }
                }
            }
        }
        JSONListModel { id: activityEvaluationModel; source: internal.baseServer + "/evaluate_activity/" + model.id + "/" + userModel.json.id + "/1" }
        MyGroupBox {
            title: "Avalie esta Atividade"
            RowLayout {
                Repeater {
                    model: 5
                    Label {
                        text: "\uf006";
                        Layout.preferredWidth: internal.maxIconWidth;
                        horizontalAlignment: Text.AlignHCenter;
                        font { family: fontAwesome.name; pointSize: 12; bold: false }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        x = ApplicationWindow.width/2
                        y = ApplicationWindow.height/2
                        dialog.open()
                    }
                }
            }
        }
    }
    Popup {
        id: dialog
        x: (parent.width - width)/2
        y: (parent.height - height)/2
        modal: true

        property var adjustedActivityEndTime

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15
            Label {
                width: parent.width
                text: "<b>Avalie esta Atividade</b>"
                horizontalAlignment: Label.AlignHCenter
            }
            Label {
                id: warningLabel
                width: parent.width
                wrapMode: Label.Wrap
                horizontalAlignment: Label.AlignHCenter
            }
            RowLayout {
                id: starLayout
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: 5
                    Label {
                        text: (index == 0) ? "\uf005":"\uf006"
                        color: (index == 0) ? "#41cd52":"black"
                        Layout.preferredWidth: internal.maxIconWidth*2
                        Layout.preferredHeight: internal.maxIconWidth*2
                        horizontalAlignment: Text.AlignHCenter
                        font { family: fontAwesome.name; pointSize: 24; bold: false }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                for (var i = 1; i < 6; ++i) {
                                    starLayout.children[i].color = (i <= index) ? "#41cd52":"black"
                                    starLayout.children[i].text = (i <= index) ? "\uf005":"\uf006"
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                width: parent.width
                height: 48
                BusyIndicator {
                    anchors.centerIn: parent
                    visible: activityEvaluationModel.state == "loading"
                }
                Label {
                    id: submissionLabel
                    anchors.centerIn: parent
                    visible: activityEvaluationModel.state == "ready" && activityEvaluationModel.json.id !== undefined
                    text: "Obrigado pela sua avaliação!"
                    color: "#41cd52"
                }
            }
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: submitButton
                    text: "Ok";
                    enabled: !(activityEvaluationModel.state == "ready" && activityEvaluationModel.json.id !== undefined)
                    onClicked: {
                        for (var i = 1; i < 6; ++i)
                            if (starLayout.children[i].text !== "\uf005")
                                break;
                        activityEvaluationModel.source = activityEvaluationModel.source.substring(0, activityEvaluationModel.source.length-1) + i
                        activityEvaluationModel.load()
                    }
                }
                Button {
                    text: "Fechar";
                    onClicked: dialog.close()
                }
            }
        }
        onOpened: checkEvaluationTime()
        Component.onCompleted: checkEvaluationTime()
        function checkEvaluationTime() {
            adjustedActivityEndTime = new Date(flickable.model.end_date)
            adjustedActivityEndTime.setHours(adjustedActivityEndTime.getHours()+3)
            adjustedActivityEndTime.setMinutes(adjustedActivityEndTime.getMinutes()-10)
            if ((new Date()) < adjustedActivityEndTime) {
                warningLabel.text = "Você poderá avaliar esta atividade a partir de " + dialog.adjustedActivityEndTime.toLocaleDateString() + " " + dialog.adjustedActivityEndTime.toLocaleTimeString()
                warningLabel.visible = true
                starLayout.visible = false
                submitButton.enabled = false
            } else {
                warningLabel.visible = false
                starLayout.visible = true
                submitButton.enabled = true
            }
        }
    }
    ScrollIndicator.vertical: ScrollIndicator { }
}
