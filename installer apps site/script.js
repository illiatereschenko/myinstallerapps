// ==========================================
// MyInstaller
// ==========================================


let selectedPrograms = [];

let currentCategory = "all";


// ==========================================
// SELECT PROGRAM
// ==========================================

function toggleProgram(button, programName) {

    if (selectedPrograms.includes(programName)) {

        selectedPrograms =
            selectedPrograms.filter(
                program => program !== programName
            );

        button.classList.remove("selected");

        button.innerHTML = "+";

    } else {

        selectedPrograms.push(programName);

        button.classList.add("selected");

        button.innerHTML = "✓";
    }


    updateCounter();
}


// ==========================================
// COUNTER
// ==========================================

function updateCounter() {

    const counter =
        document.getElementById(
            "selectedCount"
        );


    const text =
        document.getElementById(
            "selectedText"
        );


    counter.textContent =
        selectedPrograms.length;


    if (selectedPrograms.length === 0) {

        text.textContent =
            "Select programs to continue";

    } else {

        text.textContent =
            selectedPrograms.length +
            " program(s) selected";
    }
}


// ==========================================
// CATEGORY FILTER
// ==========================================

function filterCategory(category, button) {

    currentCategory = category;


    document
        .querySelectorAll(".category")
        .forEach(btn => {

            btn.classList.remove("active");

        });


    button.classList.add("active");


    showPrograms();
}


// ==========================================
// SHOW PROGRAMS
// ==========================================

function showPrograms() {

    const searchValue =
        document
            .getElementById("search")
            .value
            .toLowerCase();


    const cards =
        document.querySelectorAll(
            ".program-card"
        );


    const titles =
        document.querySelectorAll(
            ".category-title"
        );


    cards.forEach(card => {

        const category =
            card.dataset.category;


        const name =
            card.dataset.name.toLowerCase();


        const categoryMatch =
            currentCategory === "all" ||
            category === currentCategory;


        const searchMatch =
            name.includes(searchValue);


        if (
            categoryMatch &&
            searchMatch
        ) {

            card.style.display = "flex";

        } else {

            card.style.display = "none";
        }

    });


    titles.forEach(title => {

        title.style.display =
            currentCategory === "all" &&
            searchValue === ""
                ? "block"
                : "none";

    });
}


// ==========================================
// SEARCH
// ==========================================

function searchPrograms() {

    showPrograms();

}


// ==========================================
// SCROLL
// ==========================================

function scrollToPrograms() {

    document
        .getElementById("programs")
        .scrollIntoView({
            behavior: "smooth"
        });
}


// ==========================================
// REAL INSTALL
// ==========================================

function installPrograms() {

    if (selectedPrograms.length === 0) {

        alert(
            "Please select at least one program."
        );

        return;
    }


    /*
        Build MyInstaller protocol.

        Example:

        myinstaller://install?apps=
        Google%20Chrome,
        VLC%20Media%20Player,
        7-Zip
    */


    const encodedApps =
        selectedPrograms
            .map(program =>
                encodeURIComponent(program)
            )
            .join(",");


    const installerURL =
        "myinstaller://install?apps=" +
        encodedApps;


    /*
        Ask Windows to open MyInstaller
    */


    const confirmed =
        confirm(
            "MyInstaller will install " +
            selectedPrograms.length +
            " program(s).\n\n" +
            "Continue?"
        );


    if (!confirmed) {

        return;
    }


    window.location.href =
        installerURL;
}


// ==========================================
// DARK / LIGHT THEME
// ==========================================

function toggleTheme() {

    document.body
        .classList
        .toggle("light");


    const button =
        document.querySelector(
            ".theme-btn"
        );


    if (
        document.body
            .classList
            .contains("light")
    ) {

        button.innerHTML = "☀️";

    } else {

        button.innerHTML = "🌙";
    }
}


// ==========================================
// START
// ==========================================

updateCounter();

showPrograms();