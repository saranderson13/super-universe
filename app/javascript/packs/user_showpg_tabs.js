window.addEventListener('DOMContentLoaded', (e) => {
    const tabs = document.getElementsByClassName('rpanel_tab')
    Array.from(tabs).forEach( el => el.addEventListener("click", change_tab_view));
})

function change_tab_view() {
    const tabs = document.getElementsByClassName('rpanel_tab')
    const contentOptions = document.querySelectorAll('[data-marker="selectable"]')

    Array.from(tabs).forEach ( t => {
        if(this.id.split("_")[1] === t.id.split("_")[1]) {
            t.className = "rpanel_tab tab_selected";
        } else {
            t.className = "rpanel_tab";
        }
    })

    Array.from(contentOptions).forEach ( n => {
        if (this.id.split("_")[1] === n.id.split("_")[1]) {
            n.className = "content_active"
        } else {
            n.className = "content_deselected"
        }
    })

}