<%@ page import="java.sql.*" %>
<%@ page import="tz.udom.quiz.util.DBConnection" %>

<%
    // ============================================================
    // ADMIN AUTHENTICATION
    // ============================================================

    if (session == null
            || !Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))
            || !"ADMIN".equals(session.getAttribute("userRole"))) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp?error=adminLoginRequired"
        );
        return;
    }

    String adminFirstName =
            (String) session.getAttribute("adminFirstName");

    String adminLastName =
            (String) session.getAttribute("adminLastName");

    String message = request.getParameter("message");
    String error = request.getParameter("error");

    int selectedTeacherId = 0;

    try {
        if (request.getParameter("teacherId") != null) {
            selectedTeacherId =
                    Integer.parseInt(request.getParameter("teacherId"));
        }
    } catch (NumberFormatException ignored) {
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Assign Courses | UDOM Online Quiz System</title>

    <!-- Bootstrap -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Dashboard CSS -->
    <link
        rel="stylesheet"
        href="<%= request.getContextPath() %>/css/dashboard.css">

</head>

<body>

<div class="container-fluid">

    <div class="row">

        <!-- =====================================================
             SIDEBAR
             ===================================================== -->

        <div class="col-lg-2 col-md-3 p-0">

            <div class="sidebar">

                <div class="sidebar-brand">

                    <div class="brand-icon">
                        <i class="bi bi-mortarboard-fill"></i>
                    </div>

                    <div>
                        <strong>UDOM</strong>
                        <small>Online Quiz</small>
                    </div>

                </div>

                <hr>

                <div class="sidebar-menu">

                    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                        <i class="bi bi-speedometer2"></i>
                        Dashboard
                    </a>

                    <a href="<%= request.getContextPath() %>/admin/create-teacher.jsp">
                        <i class="bi bi-person-plus-fill"></i>
                        Create Teacher
                    </a>

                    <a href="<%= request.getContextPath() %>/admin/manage-teachers.jsp">
                        <i class="bi bi-people-fill"></i>
                        Manage Teachers
                    </a>

                    <a href="<%= request.getContextPath() %>/admin/assign-courses.jsp"
                       class="active">
                        <i class="bi bi-journal-bookmark-fill"></i>
                        Assign Courses
                    </a>

                </div>

                <div class="sidebar-bottom">

                    <a href="<%= request.getContextPath() %>/logout"
                       class="logout-link">

                        <i class="bi bi-box-arrow-right"></i>
                        Logout

                    </a>

                </div>

            </div>

        </div>


        <!-- =====================================================
             MAIN CONTENT
             ===================================================== -->

        <div class="col-lg-10 col-md-9">

            <div class="main-content">

                <!-- TOP NAVBAR -->

                <div class="topbar">

                    <div>

                        <h4 class="mb-1">
                            Assign Courses
                        </h4>

                        <small class="text-muted">
                            Assign academic courses to teachers
                        </small>

                    </div>

                    <div class="user-info">

                        <div class="user-avatar">
                            <%= adminFirstName != null
                                    ? adminFirstName.substring(0, 1).toUpperCase()
                                    : "A" %>
                        </div>

                        <div>

                            <strong>
                                <%= adminFirstName != null
                                        ? adminFirstName
                                        : "Administrator" %>
                                <%= adminLastName != null
                                        ? adminLastName
                                        : "" %>
                            </strong>

                            <small>
                                Administrator
                            </small>

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     ALERTS
                     ================================================= -->

                <% if ("success".equals(message)) { %>

                    <div class="alert alert-success alert-dismissible fade show mt-4">

                        <i class="bi bi-check-circle-fill me-2"></i>

                        Courses assigned successfully.

                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="alert">
                        </button>

                    </div>

                <% } %>


                <% if ("error".equals(error)) { %>

                    <div class="alert alert-danger alert-dismissible fade show mt-4">

                        <i class="bi bi-exclamation-triangle-fill me-2"></i>

                        Unable to assign the selected courses.

                        <button type="button"
                                class="btn-close"
                                data-bs-dismiss="alert">
                        </button>

                    </div>

                <% } %>


                <!-- =================================================
                     ASSIGNMENT CARD
                     ================================================= -->

                <div class="card shadow-sm border-0 mt-4">

                    <div class="card-header bg-white py-3">

                        <h5 class="mb-1">

                            <i class="bi bi-person-workspace me-2"></i>

                            Assign Courses to Teacher

                        </h5>

                        <small class="text-muted">

                            Select a teacher, programme and year of study
                            to view the available courses.

                        </small>

                    </div>


                    <div class="card-body">

                        <!-- =================================================
                             TEACHER
                             ================================================= -->

                        <div class="mb-4">

                            <label class="form-label fw-semibold">

                                Teacher

                            </label>

                            <select
                                id="teacherSelect"
                                class="form-select"
                                onchange="loadCourses()">

                                <option value="">

                                    -- Select Teacher --

                                </option>

                                <%
                                    try (Connection conn =
                                            DBConnection.getConnection();

                                         PreparedStatement ps =
                                            conn.prepareStatement(
                                                "SELECT id, first_name, middle_name, last_name, staff_number " +
                                                "FROM teachers " +
                                                "ORDER BY first_name, last_name"
                                            );

                                         ResultSet rs = ps.executeQuery()) {

                                        while (rs.next()) {

                                            int teacherId = rs.getInt("id");

                                            String firstName =
                                                    rs.getString("first_name");

                                            String middleName =
                                                    rs.getString("middle_name");

                                            String lastName =
                                                    rs.getString("last_name");

                                            String staffNumber =
                                                    rs.getString("staff_number");
                                %>

                                    <option
                                        value="<%= teacherId %>"
                                        <%= selectedTeacherId == teacherId
                                                ? "selected"
                                                : "" %>>

                                        <%= firstName %>
                                        <%= middleName != null
                                                ? middleName + " "
                                                : "" %>
                                        <%= lastName %>

                                        —
                                        <%= staffNumber %>

                                    </option>

                                <%
                                        }

                                    } catch (SQLException e) {

                                        e.printStackTrace();

                                %>

                                    <option disabled>
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

                        <div class="mb-4">

                            <label class="form-label fw-semibold">

                                Programme

                            </label>

                            <select
                                id="programmeSelect"
                                class="form-select"
                                onchange="loadCourses()">

                                <option value="">

                                    -- Select Programme --

                                </option>

                                <%
                                    try (Connection conn =
                                            DBConnection.getConnection();

                                         PreparedStatement ps =
                                            conn.prepareStatement(
                                                "SELECT id, name " +
                                                "FROM programmes " +
                                                "ORDER BY name"
                                            );

                                         ResultSet rs = ps.executeQuery()) {

                                        while (rs.next()) {
                                %>

                                    <option value="<%= rs.getInt("id") %>">

                                        <%= rs.getString("name") %>

                                    </option>

                                <%
                                        }

                                    } catch (SQLException e) {

                                        e.printStackTrace();

                                %>

                                    <option disabled>
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

                        <div class="mb-4">

                            <label class="form-label fw-semibold">

                                Year of Study

                            </label>

                            <select
                                id="yearSelect"
                                class="form-select"
                                onchange="loadCourses()">

                                <option value="">

                                    -- Select Year --

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


                        <!-- =================================================
                             AVAILABLE COURSES
                             ================================================= -->

                        <div class="mb-4">

                            <label class="form-label fw-semibold">

                                Available Courses

                            </label>

                            <div
                                id="courseContainer"
                                class="border rounded p-3">

                                <div class="text-center text-muted py-4">

                                    <i class="bi bi-arrow-up-circle fs-2"></i>

                                    <p class="mb-0 mt-2">

                                        Select teacher, programme and year
                                        to view courses.

                                    </p>

                                </div>

                            </div>

                        </div>


                        <!-- =================================================
                             ASSIGN BUTTON
                             ================================================= -->

                        <div class="text-end">

                            <button
                                type="button"
                                class="btn btn-primary px-4"
                                onclick="assignCourses()">

                                <i class="bi bi-check-circle me-2"></i>

                                Assign Selected Courses

                            </button>

                        </div>

                    </div>

                </div>


                <!-- =================================================
                     CURRENT ASSIGNMENTS
                     ================================================= -->

                <div class="card shadow-sm border-0 mt-4">

                    <div class="card-header bg-white py-3">

                        <h5 class="mb-0">

                            <i class="bi bi-list-check me-2"></i>

                            Current Teacher Assignments

                        </h5>

                    </div>

                    <div class="card-body p-0">

                        <div class="table-responsive">

                            <table class="table table-hover mb-0">

                                <thead>

                                <tr>

                                    <th>Teacher</th>

                                    <th>Staff Number</th>

                                    <th>Programme</th>

                                    <th>Year</th>

                                    <th>Course</th>

                                    <th>Course Name</th>

                                </tr>

                                </thead>

                                <tbody>

                                <%
                                    try (Connection conn =
                                            DBConnection.getConnection();

                                         PreparedStatement ps =
                                            conn.prepareStatement(
                                                "SELECT " +
                                                "t.first_name, " +
                                                "t.last_name, " +
                                                "t.staff_number, " +
                                                "p.name AS programme, " +
                                                "c.year_of_study, " +
                                                "c.course_code, " +
                                                "c.course_name " +
                                                "FROM teacher_courses tc " +
                                                "JOIN teachers t ON tc.teacher_id = t.id " +
                                                "JOIN courses c ON tc.course_id = c.id " +
                                                "JOIN programmes p ON c.programme_id = p.id " +
                                                "ORDER BY t.first_name, t.last_name, p.name, c.year_of_study, c.course_code"
                                            );

                                         ResultSet rs = ps.executeQuery()) {

                                        boolean hasAssignments = false;

                                        while (rs.next()) {

                                            hasAssignments = true;
                                %>

                                <tr>

                                    <td>
                                        <%= rs.getString("first_name") %>
                                        <%= rs.getString("last_name") %>
                                    </td>

                                    <td>
                                        <%= rs.getString("staff_number") %>
                                    </td>

                                    <td>
                                        <%= rs.getString("programme") %>
                                    </td>

                                    <td>
                                        Year
                                        <%= rs.getInt("year_of_study") %>
                                    </td>

                                    <td>

                                        <span class="badge bg-primary">

                                            <%= rs.getString("course_code") %>

                                        </span>

                                    </td>

                                    <td>
                                        <%= rs.getString("course_name") %>
                                    </td>

                                </tr>

                                <%
                                        }

                                        if (!hasAssignments) {
                                %>

                                <tr>

                                    <td colspan="6"
                                        class="text-center text-muted py-4">

                                        No course assignments have been made yet.

                                    </td>

                                </tr>

                                <%
                                        }

                                    } catch (SQLException e) {

                                        e.printStackTrace();
                                %>

                                <tr>

                                    <td colspan="6"
                                        class="text-center text-danger py-4">

                                        Unable to load assignments.

                                    </td>

                                </tr>

                                <%
                                    }
                                %>

                                </tbody>

                            </table>

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>


<!-- =============================================================
     JAVASCRIPT
     ============================================================= -->

<script>

function loadCourses() {

    const teacherId =
        document.getElementById("teacherSelect").value;

    const programmeId =
        document.getElementById("programmeSelect").value;

    const year =
        document.getElementById("yearSelect").value;

    const container =
        document.getElementById("courseContainer");


    if (!teacherId || !programmeId || !year) {

        container.innerHTML = `
            <div class="text-center text-muted py-4">

                <i class="bi bi-arrow-up-circle fs-2"></i>

                <p class="mb-0 mt-2">

                    Select teacher, programme and year
                    to view courses.

                </p>

            </div>
        `;

        return;
    }


    container.innerHTML = `
        <div class="text-center py-4">

            <div class="spinner-border text-primary"></div>

            <p class="mt-2 text-muted">

                Loading courses...

            </p>

        </div>
    `;


    fetch(
        "<%= request.getContextPath() %>/assignCourse?teacherId="
        + encodeURIComponent(teacherId)
        + "&programmeId="
        + encodeURIComponent(programmeId)
        + "&year="
        + encodeURIComponent(year)
        + "&action=list"
    )

    .then(response => {

        if (!response.ok) {
            throw new Error("Failed to load courses");
        }

        return response.json();

    })

    .then(courses => {

        if (courses.length === 0) {

            container.innerHTML = `
                <div class="alert alert-warning mb-0">

                    <i class="bi bi-info-circle me-2"></i>

                    No courses were found for this programme
                    and year.

                </div>
            `;

            return;
        }


        let html = "";

        courses.forEach(course => {

            html += `

                <div class="form-check border-bottom py-3">

                    <input
                        class="form-check-input course-checkbox"
                        type="checkbox"
                        value="${course.id}"
                        id="course${course.id}"
                        ${course.assigned ? "checked" : ""}>

                    <label
                        class="form-check-label"
                        for="course${course.id}">

                        <strong>
                            ${course.courseCode}
                        </strong>

                        -
                        ${course.courseName}

                        ${
                            course.assigned
                            ? '<span class="badge bg-success ms-2">Assigned</span>'
                            : ''
                        }

                    </label>

                </div>

            `;

        });


        container.innerHTML = html;

    })

    .catch(error => {

        console.error(error);

        container.innerHTML = `
            <div class="alert alert-danger mb-0">

                Unable to load courses.

            </div>
        `;

    });

}


function assignCourses() {

    const teacherId =
        document.getElementById("teacherSelect").value;

    const programmeId =
        document.getElementById("programmeSelect").value;

    const year =
        document.getElementById("yearSelect").value;


    if (!teacherId || !programmeId || !year) {

        alert(
            "Please select a teacher, programme and year."
        );

        return;
    }


    const selectedCourses =
        document.querySelectorAll(
            ".course-checkbox:checked"
        );


    if (selectedCourses.length === 0) {

        alert(
            "Please select at least one course."
        );

        return;
    }


    const form =
        document.createElement("form");

    form.method = "POST";

    form.action =
        "<%= request.getContextPath() %>/assignCourse";


    const teacherInput =
        document.createElement("input");

    teacherInput.type = "hidden";
    teacherInput.name = "teacherId";
    teacherInput.value = teacherId;

    form.appendChild(teacherInput);


    selectedCourses.forEach(course => {

        const input =
            document.createElement("input");

        input.type = "hidden";

        input.name = "courseIds";

        input.value = course.value;

        form.appendChild(input);

    });


    document.body.appendChild(form);

    form.submit();

}

</script>


<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>

</html>