
document.addEventListener("DOMContentLoaded", function () {

    const navbar =
        document.querySelector(".main-navbar");

    window.addEventListener("scroll", function () {

        if (window.scrollY > 50) {

            navbar.classList.add("shadow");

        } else {

            navbar.classList.remove("shadow");

        }

    });


    /*
     * Automatically close the mobile navbar
     * after clicking a navigation link.
     */

    const navLinks =
        document.querySelectorAll(".navbar-nav .nav-link");

    const navbarCollapse =
        document.querySelector(".navbar-collapse");


    navLinks.forEach(function (link) {

        link.addEventListener("click", function () {

            if (
                navbarCollapse &&
                navbarCollapse.classList.contains("show")
            ) {

                const collapse =
                    bootstrap.Collapse.getInstance(
                        navbarCollapse
                    );

                if (collapse) {
                    collapse.hide();
                }

            }

        });

    });

});
