import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Action 1.0

Item {
    property alias model: repeater.model;

    ColumnLayout {
        spacing: 20;
        anchors.centerIn: parent;

        Repeater {
            id:repeater;

            Button {
                text:modelData.name;

                onClicked: ActionCreator.createAction(modelData.action, {});
                Layout.fillWidth: true;
            }
        }
    }
}
