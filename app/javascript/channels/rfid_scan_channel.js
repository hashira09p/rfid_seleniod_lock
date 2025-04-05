// app/javascript/channels/rfid_scan_channel.js
import { createConsumer } from "@rails/actioncable";

// Ensure global App object exists
const App = window.App || {};
App.cable = createConsumer();

App.rfid_scans = App.cable.subscriptions.create("RfidScanChannel", {
  connected() {
    console.log("✅ Successfully connected to RfidScanChannel");
  },

  disconnected() {
    console.log("⚠️ Disconnected from RfidScanChannel");
    // ActionCable will attempt to reconnect automatically, no need to resubscribe manually
  },

  received(data) {
    if (data.action === "display_uid") {
      console.log("📡 Received:", data);

      const placeholder = document.getElementById('rfid-uid-placeholder');
      const input = document.getElementById('rfid-uid-input');

      if (data.denied) {
        if (placeholder) placeholder.textContent = "Card is already in use";
        if (input) input.value = ""; // clear the hidden input so it won't submit
      } else {
        if (placeholder) placeholder.textContent = `${data.uid}`;
        if (input) input.value = data.uid;
      }
    }
  }
});