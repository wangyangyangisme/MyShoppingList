import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import Action 1.0

Item {
    property var index: -1;
    MessageDialog {
        id:messageDialog;
        title: "Error during creation of ingredient";
        text: "One of your field are empty";
        modality: Qt.ApplicationModal;
        icon: StandardIcon.Critical;
        standardButtons: StandardButton.Close;
    }

    function reset(args) {
        name.text = "";
        price.text = "";
        index = args;
    }

    ColumnLayout {
        id: column;
        anchors.centerIn: parent;
        spacing: 20;

        TextField {
            id:name;
            placeholderText: "Enter the name of the new Ingredient";
            Layout.fillWidth: true;
        }

        TextField {
            id:price;
            placeholderText: "Enter the price of the new Ingredient";
            validator: DoubleValidator{bottom: 0; locale: "us_US"}
            Layout.fillWidth: true;
        }

        Button {
            text: "Create";
            Layout.fillWidth: true;
            onClicked: {
                if(name.text != "" && price.text != "") {
                    CategoryModel.addIngredient(index, {name:name.text, price:price.text});
                    stackView.resetPop();
                }

                else
                    messageDialog.open();
            }
        }
    }
}
