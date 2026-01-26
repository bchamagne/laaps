// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/laaps"
import topbar from "../vendor/topbar"

const LocalStorageForm = {
  mounted() {
    // Load saved form data from localStorage using separate keys
    const firstnameInput = this.el.querySelector('[name="participant[firstname]"]')
    const lastnameInput = this.el.querySelector('[name="participant[lastname]"]')
    const countInput = this.el.querySelector('[name="participant[count]"]')
    
    // Load and set firstname
    const savedFirstname = localStorage.getItem('laaps_firstname')
    if (firstnameInput && savedFirstname) {
      firstnameInput.value = savedFirstname
      firstnameInput.dispatchEvent(new Event('input', { bubbles: true }))
    }
    
    // Load and set lastname
    const savedLastname = localStorage.getItem('laaps_lastname')
    if (lastnameInput && savedLastname) {
      lastnameInput.value = savedLastname
      lastnameInput.dispatchEvent(new Event('input', { bubbles: true }))
    }
    
    // Load and set count
    const savedCount = localStorage.getItem('laaps_count')
    if (countInput && savedCount) {
      countInput.value = savedCount
      countInput.dispatchEvent(new Event('input', { bubbles: true }))
    }
    
    // Add event listeners to save on input changes
    this.saveFormData = this.saveFormData.bind(this)
    const form = this.el
    form.addEventListener('input', this.saveFormData)
  },
  
  destroyed() {
    // Remove event listener
    this.el.removeEventListener('input', this.saveFormData)
    // Save final state
    this.saveFormData()
  },
  
  saveFormData() {
    const firstnameInput = this.el.querySelector('[name="participant[firstname]"]')
    const lastnameInput = this.el.querySelector('[name="participant[lastname]"]')
    const countInput = this.el.querySelector('[name="participant[count]"]')
    
    // Save each field to separate localStorage keys
    if (firstnameInput) {
      localStorage.setItem('laaps_firstname', firstnameInput.value || '')
    }
    
    if (lastnameInput) {
      localStorage.setItem('laaps_lastname', lastnameInput.value || '')
    }
    
    if (countInput) {
      localStorage.setItem('laaps_count', countInput.value || '1')
    }
  }
}

const SettingsLocalStorage = {
  mounted() {
    // Load saved form data from localStorage using separate keys
    const firstnameInput = this.el.querySelector('[name="settings[firstname]"]')
    const lastnameInput = this.el.querySelector('[name="settings[lastname]"]')
    const countInput = this.el.querySelector('[name="settings[count]"]')
    
    // Load and set firstname
    const savedFirstname = localStorage.getItem('laaps_firstname')
    if (firstnameInput && savedFirstname) {
      firstnameInput.value = savedFirstname
      firstnameInput.dispatchEvent(new Event('input', { bubbles: true }))
    }
    
    // Load and set lastname
    const savedLastname = localStorage.getItem('laaps_lastname')
    if (lastnameInput && savedLastname) {
      lastnameInput.value = savedLastname
      lastnameInput.dispatchEvent(new Event('input', { bubbles: true }))
    }
    
    // Load and set count
    const savedCount = localStorage.getItem('laaps_count')
    if (countInput && savedCount) {
      countInput.value = savedCount
      countInput.dispatchEvent(new Event('input', { bubbles: true }))
    }
    
    // Add event listener to save on form submit
    this.saveSettings = this.saveSettings.bind(this)
    this.el.addEventListener('submit', this.saveSettings)
  },
  
  destroyed() {
    // Remove event listener
    this.el.removeEventListener('submit', this.saveSettings)
  },
  
  saveSettings(e) {
    // Prevent default form submission since we're using LiveView
    // LiveView will handle the phx-submit, we just save to localStorage
    const firstnameInput = this.el.querySelector('[name="settings[firstname]"]')
    const lastnameInput = this.el.querySelector('[name="settings[lastname]"]')
    const countInput = this.el.querySelector('[name="settings[count]"]')
    
    // Save each field to separate localStorage keys
    if (firstnameInput) {
      localStorage.setItem('laaps_firstname', firstnameInput.value || '')
    }
    
    if (lastnameInput) {
      localStorage.setItem('laaps_lastname', lastnameInput.value || '')
    }
    
    if (countInput) {
      localStorage.setItem('laaps_count', countInput.value || '1')
    }
  }
}

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {LocalStorageForm, SettingsLocalStorage, ...colocatedHooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

