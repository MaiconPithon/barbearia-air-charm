import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import "./index.css";

// Handle ChunkLoadError - clear cache and reload
window.addEventListener("error", (event) => {
  if (
    event.message?.includes("ChunkLoadError") ||
    event.message?.includes("Failed to fetch dynamically imported module") ||
    event.message?.includes("Loading chunk")
  ) {
    console.warn("Chunk load error detected, reloading...");
    if ("caches" in window) {
      caches.keys().then((names) => {
        names.forEach((name) => caches.delete(name));
      });
    }
    window.location.reload();
  }
});

window.addEventListener("unhandledrejection", (event) => {
  const message = event.reason?.message || "";
  if (
    message.includes("ChunkLoadError") ||
    message.includes("Failed to fetch dynamically imported module") ||
    message.includes("Loading chunk")
  ) {
    console.warn("Chunk load error detected (promise), reloading...");
    if ("caches" in window) {
      caches.keys().then((names) => {
        names.forEach((name) => caches.delete(name));
      });
    }
    window.location.reload();
  }
});

createRoot(document.getElementById("root")!).render(<App />);
