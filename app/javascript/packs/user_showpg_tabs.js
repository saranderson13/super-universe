window.addEventListener('DOMContentLoaded', (e) => {
    const tabs = document.getElementsByClassName('rpanel_tab')
    Array.from(tabs).forEach( el => el.addEventListener("click", change_tab_view));
})

function change_tab_view() {
    debugger;
    console.log("hello")
}