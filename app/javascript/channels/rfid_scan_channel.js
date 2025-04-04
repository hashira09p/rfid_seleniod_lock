import { createConsumer } from "@rails/actioncable";

const App = App || {};

App.cable = createConsumer(); // Initialize ActionCable consumer

App.rfid_scans = App.cable.subscriptions.create("RfidScanChannel", {
  connected() {
    console.log("Successfully connected to the channel");
  },
  disconnected() {
    console.log("Disconnected from the channel. Reconnecting...");
    // Attempt to resubscribe if the connection drops
    App.rfid_scans = App.cable.subscriptions.create("RfidScanChannel", {
      received(data) {
        if (data.action === "display_uid") {
          document.getElementById('rfid-uid-placeholder').textContent = data.uid;
          document.getElementById('rfid-uid-input').value = data.uid;
        }
      }
    });
  },
  received(data) {
    if (data.action === "display_uid") {
      document.getElementById('rfid-uid-placeholder').textContent = data.uid;
      document.getElementById('rfid-uid-input').value = data.uid;
    }
  }
});
