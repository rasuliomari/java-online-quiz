<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
// =========================================================
// ADMIN AUTHENTICATION
// =========================================================

Boolean adminLoggedIn =
        (Boolean) session.getAttribute("adminLoggedIn");

if (adminLoggedIn == null || !adminLoggedIn) {

    response.sendRedirect(
            request.getContextPath() + "/login.jsp"
    );

    return;
}


String adminFirstName =
        (String) session.getAttribute("adminFirstName");

String adminLastName =
        (String) session.getAttribute("adminLastName");


String adminFullName =
        ((adminFirstName != null)
                ? adminFirstName
                : "")
        + " "
        + ((adminLastName != null)
                ? adminLastName
                : "");


// =========================================================
// SELECTED TEACHER
// =========================================================

int selectedTeacherId = 0;

String teacherIdParam =
        request.getParameter("teacherId");


if (teacherIdParam != null &&
    !teacherIdParam.trim().isEmpty()) {

    try {

        selectedTeacherId =
                Integer.parseInt(
                        teacherIdParam
                );

    } catch (NumberFormatException e) {

        selectedTeacherId = 0;
    }
}


String message =
        request.getParameter("message");

String status =
        request.getParameter("status");

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">


<title>
    Assign Courses | UDOM Online Quiz System
</title>


<!-- =====================================================
     BOOTSTRAP
     ===================================================== -->

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">


<!-- =====================================================
     BOOTSTRAP ICONS
     ===================================================== -->

<link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<!-- =====================================================
     DASHBOARD CSS
     ===================================================== -->

<link
    rel="stylesheet"
    href="<%= request.getContextPath() %>/css/dashboard.css">


<style>

    body {

        background-color: #f5f7fb;

    }


    .page-container {

        padding: 30px;

    }


    .assignment-card {

        border: none;

        border-radius: 16px;

        box-shadow:
            0 4px 20px
            rgba(0, 0, 0, 0.08);

    }


    .page-title {

        font-weight: 700;

        color: #1f2937;

    }


    .page-subtitle {

        color: #6b7280;

    }


    .course-card {

        border: 1px solid #e5e7eb;

        border-radius: 12px;

        transition:
            0.2s ease;

    }


    .course-card:hover {

        border-color: #0d6efd;

        box-shadow:
            0 3px 12px
            rgba(13, 110, 253, 0.12);

    }


    .course-card.assigned {

        border-color: #198754;

        background-color: #f0fff6;

    }


    .course-code {

        font-weight: 700;

        color: #0d6efd;

    }


    .course-name {

        font-weight: 600;

        color: #374151;

    }


    .assigned-badge {

        font-size: 11px;

    }


    .empty-state {

        padding: 50px 20px;

        text-align: center;

        color: #6b7280;

    }


    .filter-card {

        background: white;

        border-radius: 16px;

        border: none;

        box-shadow:
            0 4px 20px
            rgba(0, 0, 0, 0.06);

    }


    .top-navbar {

        background: #ffffff;

        border-bottom:
            1px solid #e5e7eb;

        min-height: 70px;

    }


    .brand-title {

        font-weight: 700;

        color: #0d6efd;

    }


    .admin-avatar {

        width: 40px;

        height: 40px;

        border-radius: 50%;

        background: #0d6efd;

        color: white;

        display: flex;

        align-items: center;

        justify-content: center;

        font-weight: 700;

    }


    .course-counter {

        font-size: 14px;

        color: #6b7280;

    }


    .selected-filter {

        font-size: 13px;

        color: #6b7280;

        margin-top: 6px;

    }

</style>

</head>

<body>

<!-- =========================================================
     TOP NAVBAR
     ========================================================= -->

<nav class="navbar top-navbar px-4">

<div class="container-fluid">


    <div class="d-flex align-items-center">

        <i class="bi bi-mortarboard-fill
                  fs-3 text-primary me-2"></i>

        <span class="brand-title fs-5">

            UDOM Online Quiz System

        </span>

    </div>


    <div class="d-flex align-items-center gap-3">


        <div class="text-end d-none d-md-block">

            <div class="fw-semibold">

                <%= adminFullName.trim() %>

            </div>

            <small class="text-muted">

                Administrator

            </small>

        </div>


        <div class="admin-avatar">

            <%

                String avatarLetter = "A";


                if (adminFirstName != null &&
                    !adminFirstName.trim().isEmpty()) {

                    avatarLetter =
                            adminFirstName
                            .substring(0, 1)
                            .toUpperCase();

                }

            %>

            <%= avatarLetter %>

        </div>


        <a href="<%= request.getContextPath() %>/logout"
           class="btn btn-outline-danger btn-sm">

            <i class="bi bi-box-arrow-right"></i>

            Logout

        </a>

    </div>

</div>

</nav>

<!-- =========================================================
     MAIN CONTENT
     ========================================================= -->

<div class="container-fluid page-container">

<!-- =====================================================
     PAGE HEADER
     ===================================================== -->

<div class="d-flex
            justify-content-between
            align-items-center
            mb-4">


    <div>

        <h2 class="page-title mb-1">

            <i class="bi bi-journal-bookmark-fill
                      text-primary me-2"></i>

            Assign Courses

        </h2>


        <p class="page-subtitle mb-0">

            Assign academic courses to a teacher.

        </p>

    </div>


    <div>

        <a href="manage-teachers.jsp"
           class="btn btn-outline-secondary">

            <i class="bi bi-arrow-left"></i>

            Back to Teachers

        </a>

    </div>

</div>



<!-- =====================================================
     ALERT MESSAGE
     ===================================================== -->

<%

    if (message != null &&
        !message.trim().isEmpty()) {

%>


    <div class="alert
        <%= "success".equals(status)
            ? "alert-success"
            : "alert-danger" %>
        alert-dismissible fade show">


        <i class="bi
            <%= "success".equals(status)
                ? "bi-check-circle"
                : "bi-exclamation-triangle" %>
            me-2"></i>


        <%= message %>


        <button type="button"
                class="btn-close"
                data-bs-dismiss="alert">
        </button>

    </div>


<%

    }

%>



<!-- =====================================================
     FILTER CARD
     ===================================================== -->

<div class="card filter-card mb-4">


    <div class="card-body p-4">


        <div class="row g-4">


            <!-- =================================================
                 TEACHER
                 ================================================= -->

            <div class="col-md-4">


                <label class="form-label fw-semibold">

                    <i class="bi bi-person-badge me-1"></i>

                    Teacher

                </label>


                <select id="teacherId"
                        class="form-select"
                        required>


                    <option value="">

                        Select Teacher

                    </option>


                    <%

                        try (
                            Connection connection =
                                DBConnection.getConnection();

                            PreparedStatement statement =
                                connection.prepareStatement(

                                    "SELECT id, first_name, middle_name, " +
                                    "last_name, staff_number " +
                                    "FROM teachers " +
                                    "ORDER BY first_name, last_name"

                                );

                            ResultSet resultSet =
                                statement.executeQuery()
                        ) {


                            while (resultSet.next()) {


                                int teacherId =
                                        resultSet.getInt("id");


                                String firstName =
                                        resultSet.getString(
                                                "first_name"
                                        );


                                String middleName =
                                        resultSet.getString(
                                                "middle_name"
                                        );


                                String lastName =
                                        resultSet.getString(
                                                "last_name"
                                        );


                                String staffNumber =
                                        resultSet.getString(
                                                "staff_number"
                                        );


                                String fullName =
                                        firstName;


                                if (middleName != null &&
                                    !middleName.trim().isEmpty()) {

                                    fullName +=
                                            " " + middleName;

                                }


                                fullName +=
                                        " " + lastName;

                    %>


                        <option value="<%= teacherId %>"
                            <%= teacherId == selectedTeacherId
                                ? "selected"
                                : "" %>>

                            <%= fullName %>
                            - <%= staffNumber %>

                        </option>


                    <%

                            }

                        } catch (Exception e) {

                            e.printStackTrace();

                    %>


                        <option value="">

                            Unable to load teachers

                        </option>


                    <%

                        }

                    %>

                </select>

            </div>



            <!-- =================================================
                 PROGRAMME
                 ================================================= -->

            <div class="col-md-4">


                <label class="form-label fw-semibold">

                    <i class="bi bi-mortarboard me-1"></i>

                    Programme

                </label>


                <select id="programmeId"
                        class="form-select"
                        required>


                    <option value="">

                        Select Programme

                    </option>


                    <%

                        try (
                            Connection connection =
                                DBConnection.getConnection();

                            PreparedStatement statement =
                                connection.prepareStatement(

                                    "SELECT id, name " +
                                    "FROM programmes " +
                                    "ORDER BY name"

                                );

                            ResultSet resultSet =
                                statement.executeQuery()
                        ) {


                            while (resultSet.next()) {


                                int programmeId =
                                        resultSet.getInt("id");


                                String programmeName =
                                        resultSet.getString(
                                                "name"
                                        );

                    %>


                        <option value="<%= programmeId %>">

                            <%= programmeName %>

                        </option>


                    <%

                            }

                        } catch (Exception e) {

                            e.printStackTrace();

                    %>


                        <option value="">

                            Unable to load programmes

                        </option>


                    <%

                        }

                    %>

                </select>

            </div>



            <!-- =================================================
                 YEAR
                 ================================================= -->

            <div class="col-md-4">


                <label class="form-label fw-semibold">

                    <i class="bi bi-calendar3 me-1"></i>

                    Year of Study

                </label>


                <select id="yearOfStudy"
                        class="form-select"
                        required>


                    <option value="">

                        Select Year

                    </option>


                    <option value="1">

                        Year 1

                    </option>


                    <option value="2">

                        Year 2

                    </option>


                    <option value="3">

                        Year 3

                    </option>


                    <option value="4">

                        Year 4

                    </option>


                </select>

            </div>

        </div>

    </div>

</div>



<!-- =====================================================
     COURSE CARD
     ===================================================== -->

<div class="card assignment-card">


    <div class="card-header
                bg-white
                border-0
                p-4">


        <div class="d-flex
                    justify-content-between
                    align-items-center">


            <div>


                <h5 class="mb-1 fw-bold">

                    Available Courses

                </h5>


                <div class="course-counter">

                    Select the courses that should be
                    assigned to the selected teacher.

                </div>


                <div id="selectedFilter"
                     class="selected-filter">

                </div>

            </div>


            <div>

                <span id="courseCount"
                      class="badge bg-secondary">

                    0 Courses

                </span>

            </div>

        </div>

    </div>



    <div class="card-body p-4">


        <!-- =================================================
             LOADING
             ================================================= -->

        <div id="loadingCourses"
             class="text-center py-5 d-none">


            <div class="spinner-border text-primary"
                 role="status">

            </div>


            <p class="mt-3 text-muted">

                Loading courses...

            </p>

        </div>



        <!-- =================================================
             COURSE LIST
             ================================================= -->

        <div id="courseList"
             class="row g-3">


            <div class="col-12">


                <div class="empty-state">


                    <i class="bi bi-journal-x fs-1"></i>


                    <h5 class="mt-3">

                        Select a programme and year

                    </h5>


                    <p>

                        Courses will appear here.

                    </p>

                </div>

            </div>

        </div>



        <!-- =================================================
             SAVE BUTTON
             ================================================= -->

        <div class="d-flex
                    justify-content-end
                    mt-4">


            <button type="button"
                    id="saveAssignments"
                    class="btn btn-primary"
                    disabled>


                <i class="bi bi-save me-1"></i>

                Save Course Assignments

            </button>

        </div>

    </div>

</div>

</div>

<!-- =========================================================
     BOOTSTRAP JAVASCRIPT
     ========================================================= -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>

    // =========================================================
    // CONTEXT
    // =========================================================

    const contextPath =
        "<%= request.getContextPath() %>";


    // =========================================================
    // ELEMENTS
    // =========================================================

    const teacherSelect =
        document.getElementById("teacherId");


    const programmeSelect =
        document.getElementById("programmeId");


    const yearSelect =
        document.getElementById("yearOfStudy");


    const courseList =
        document.getElementById("courseList");


    const loadingCourses =
        document.getElementById("loadingCourses");


    const saveButton =
        document.getElementById("saveAssignments");


    const courseCount =
        document.getElementById("courseCount");


    const selectedFilter =
        document.getElementById("selectedFilter");



    // =========================================================
    // SHOW EMPTY STATE
    // =========================================================

    function showEmptyState() {


        courseList.innerHTML =

            '<div class="col-12">' +

                '<div class="empty-state">' +

                    '<i class="bi bi-journal-x fs-1"></i>' +

                    '<h5 class="mt-3">' +

                        'Select a programme and year' +

                    '</h5>' +

                    '<p>' +

                        'Courses will appear here.' +

                    '</p>' +

                '</div>' +

            '</div>';


        courseCount.textContent =
            "0 Courses";


        selectedFilter.textContent =
            "";


        saveButton.disabled =
            true;

    }



    // =========================================================
    // LOAD COURSES
    // =========================================================

    async function loadCourses() {


        const teacherId =
            teacherSelect.value;


        const programmeId =
            programmeSelect.value;


        const year =
            yearSelect.value;



        // -----------------------------------------------------
        // REQUIRE ALL THREE VALUES
        // -----------------------------------------------------

        if (!teacherId ||
            !programmeId ||
            !year) {

            showEmptyState();

            return;

        }



        // -----------------------------------------------------
        // RESET COURSE LIST
        // -----------------------------------------------------

        courseList.innerHTML = "";

        courseCount.textContent =
            "0 Courses";

        saveButton.disabled =
            true;


        selectedFilter.textContent =
            "Loading courses for Year " + year + "...";


        loadingCourses.classList.remove(
            "d-none"
        );



        try {


            // =================================================
            // BUILD REQUEST
            // =================================================

            const url =
                contextPath +
                "/assignCourse?action=list" +
                "&teacherId=" +
                encodeURIComponent(teacherId) +
                "&programmeId=" +
                encodeURIComponent(programmeId) +
                "&year=" +
                encodeURIComponent(year) +
                "&_=" +
                Date.now();



            console.log(
                "Loading courses:",
                url
            );



            // =================================================
            // REQUEST
            // =================================================

            const response =
                await fetch(
                    url,
                    {
                        method: "GET",
                        cache: "no-store",
                        headers: {
                            "Accept":
                                "application/json"
                        }
                    }
                );



            // =================================================
            // CHECK HTTP STATUS
            // =================================================

            if (!response.ok) {

                throw new Error(
                    "HTTP " +
                    response.status
                );

            }



            // =================================================
            // READ JSON
            // =================================================

            const courses =
                await response.json();



            console.log(
                "Courses returned by server:",
                courses
            );



            // =================================================
            // HIDE LOADING
            // =================================================

            loadingCourses.classList.add(
                "d-none"
            );



            // =================================================
            // ENSURE ARRAY
            // =================================================

            if (!Array.isArray(courses)) {

                throw new Error(
                    "Server returned invalid course data."
                );

            }



            // =================================================
            // IMPORTANT:
            // FILTER COURSES BY SELECTED YEAR
            //
            // The database query already filters by:
            //
            // programme_id
            // +
            // year_of_study
            //
            // This additional filter prevents a course from
            // another year from accidentally appearing.
            // =================================================

            const selectedYear =
                Number(year);


            const filteredCourses =
                courses.filter(
                    function(course) {

                        return Number(
                            course.year_of_study
                        ) === selectedYear;

                    }
                );



            console.log(
                "Selected year:",
                selectedYear
            );


            console.log(
                "Filtered courses:",
                filteredCourses
            );



            // =================================================
            // NO COURSES
            // =================================================

            if (
                filteredCourses.length === 0
            ) {


                courseList.innerHTML =

                    '<div class="col-12">' +

                        '<div class="empty-state">' +

                            '<i class="bi bi-journal-x fs-1"></i>' +

                            '<h5 class="mt-3">' +

                                'No courses found' +

                            '</h5>' +

                            '<p>' +

                                'There are no courses for the ' +

                                'selected programme and Year ' +

                                selectedYear +

                                '.' +

                            '</p>' +

                        '</div>' +

                    '</div>';


                courseCount.textContent =
                    "0 Courses";


                selectedFilter.textContent =
                    "Programme selected • Year " +
                    selectedYear;


                saveButton.disabled =
                    true;


                return;

            }



            // =================================================
            // COURSE COUNT
            // =================================================

            courseCount.textContent =
                filteredCourses.length +
                " Courses";


            selectedFilter.textContent =
                "Showing courses for Year " +
                selectedYear;



            // =================================================
            // CREATE COURSE CARDS
            // =================================================

            filteredCourses.forEach(
                function(course) {


                    // -----------------------------------------
                    // COLUMN
                    // -----------------------------------------

                    const column =
                        document.createElement(
                            "div"
                        );


                    column.className =
                        "col-md-6 col-lg-4";



                    // -----------------------------------------
                    // CARD
                    // -----------------------------------------

                    const card =
                        document.createElement(
                            "div"
                        );


                    card.className =
                        "course-card p-3 h-100";



                    // -----------------------------------------
                    // ASSIGNED STATUS
                    // -----------------------------------------

                    if (
                        course.assigned === true
                    ) {

                        card.classList.add(
                            "assigned"
                        );

                    }



                    // -----------------------------------------
                    // WRAPPER
                    // -----------------------------------------

                    const wrapper =
                        document.createElement(
                            "div"
                        );


                    wrapper.className =
                        "form-check";



                    // -----------------------------------------
                    // CHECKBOX
                    // -----------------------------------------

                    const checkbox =
                        document.createElement(
                            "input"
                        );


                    checkbox.type =
                        "checkbox";


                    checkbox.className =
                        "form-check-input course-checkbox";


                    checkbox.value =
                        course.id;


                    checkbox.id =
                        "course_" +
                        course.id;



                    // -----------------------------------------
                    // CURRENT ASSIGNMENT
                    // -----------------------------------------

                    if (
                        course.assigned === true
                    ) {

                        checkbox.checked =
                            true;

                    }



                    // -----------------------------------------
                    // LABEL
                    // -----------------------------------------

                    const label =
                        document.createElement(
                            "label"
                        );


                    label.className =
                        "form-check-label w-100";


                    label.setAttribute(
                        "for",
                        "course_" +
                        course.id
                    );



                    // -----------------------------------------
                    // COURSE CODE
                    // -----------------------------------------

                    const code =
                        document.createElement(
                            "div"
                        );

                    code.className =
                        "course-code";

                    code.textContent =
                        course.course_code;


                    // -----------------------------------------
                    // COURSE NAME
                    // -----------------------------------------

                    const name =
                        document.createElement(
                            "div"
                        );

                    name.className =
                        "course-name mt-1";

                    name.textContent =
                        course.course_name;



                    // -----------------------------------------
                    // YEAR
                    // -----------------------------------------

                    const yearText =
                        document.createElement(
                            "small"
                        );


                    yearText.className =
                        "text-muted d-block mt-2";


                    yearText.textContent =
                        "Year " +
                        selectedYear;



                    // -----------------------------------------
                    // ADD COURSE INFORMATION
                    // -----------------------------------------

                    label.appendChild(
                        code
                    );


                    label.appendChild(
                        name
                    );


                    label.appendChild(
                        yearText
                    );



                    // -----------------------------------------
                    // ASSIGNED BADGE
                    // -----------------------------------------

                    if (
                        course.assigned === true
                    ) {


                        const badge =
                            document.createElement(
                                "span"
                            );


                        badge.className =
                            "badge bg-success assigned-badge mt-2";


                        badge.textContent =
                            "Currently Assigned";


                        label.appendChild(
                            badge
                        );

                    }



                    // -----------------------------------------
                    // BUILD CARD
                    // -----------------------------------------

                    wrapper.appendChild(
                        checkbox
                    );


                    wrapper.appendChild(
                        label
                    );


                    card.appendChild(
                        wrapper
                    );


                    column.appendChild(
                        card
                    );


                    courseList.appendChild(
                        column
                    );

                }
            );



            // =================================================
            // ENABLE SAVE
            // =================================================

            saveButton.disabled =
                false;


        } catch (error) {


            console.error(
                "Course loading error:",
                error
            );


            loadingCourses.classList.add(
                "d-none"
            );


            courseCount.textContent =
                "0 Courses";


            selectedFilter.textContent =
                "";


            courseList.innerHTML =

                '<div class="col-12">' +

                    '<div class="alert alert-danger">' +

                        '<i class="bi bi-exclamation-triangle me-2"></i>' +

                        'Unable to load courses. ' +

                        'Please check the server logs.' +

                    '</div>' +

                '</div>';


            saveButton.disabled =
                true;

        }

    }



    // =========================================================
    // FILTER EVENTS
    // =========================================================

    teacherSelect.addEventListener(
        "change",
        loadCourses
    );


    programmeSelect.addEventListener(
        "change",
        loadCourses
    );


    yearSelect.addEventListener(
        "change",
        loadCourses
    );



    // =========================================================
    // SAVE ASSIGNMENTS
    // =========================================================

    saveButton.addEventListener(
        "click",
        function() {


            const teacherId =
                teacherSelect.value;


            const programmeId =
                programmeSelect.value;


            const year =
                yearSelect.value;



            // -------------------------------------------------
            // VALIDATE SELECTION
            // -------------------------------------------------

            if (
                !teacherId ||
                !programmeId ||
                !year
            ) {


                alert(
                    "Please select teacher, programme and year."
                );


                return;

            }



            // -------------------------------------------------
            // SELECT CHECKED COURSES
            // -------------------------------------------------

            const selectedCourses =
                document.querySelectorAll(
                    ".course-checkbox:checked"
                );



            // -------------------------------------------------
            // CREATE FORM
            // -------------------------------------------------

            const form =
                document.createElement(
                    "form"
                );


            form.method =
                "POST";


            form.action =
                contextPath +
                "/assignCourse";



            // -------------------------------------------------
            // TEACHER
            // -------------------------------------------------

            const teacherInput =
                document.createElement(
                    "input"
                );


            teacherInput.type =
                "hidden";


            teacherInput.name =
                "teacherId";


            teacherInput.value =
                teacherId;


            form.appendChild(
                teacherInput
            );



            // -------------------------------------------------
            // PROGRAMME
            // -------------------------------------------------

            const programmeInput =
                document.createElement(
                    "input"
                );


            programmeInput.type =
                "hidden";


            programmeInput.name =
                "programmeId";


            programmeInput.value =
                programmeId;


            form.appendChild(
                programmeInput
            );



            // -------------------------------------------------
            // YEAR
            // -------------------------------------------------

            const yearInput =
                document.createElement(
                    "input"
                );


            yearInput.type =
                "hidden";


            yearInput.name =
                "year";


            yearInput.value =
                year;


            form.appendChild(
                yearInput
            );



            // -------------------------------------------------
            // COURSE IDS
            // -------------------------------------------------

            selectedCourses.forEach(
                function(checkbox) {


                    const input =
                        document.createElement(
                            "input"
                        );


                    input.type =
                        "hidden";


                    input.name =
                        "courseIds";


                    input.value =
                        checkbox.value;


                    form.appendChild(
                        input
                    );

                }
            );



            // -------------------------------------------------
            // SUBMIT
            // -------------------------------------------------

            document.body.appendChild(
                form
            );


            form.submit();

        }
    );



    // =========================================================
    // INITIAL STATE
    // =========================================================

    showEmptyState();

</script>

</body>

</html>
