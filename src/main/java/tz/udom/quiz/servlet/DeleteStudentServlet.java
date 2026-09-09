package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/deleteStudent")
public class DeleteStudentServlet extends HttpServlet {

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    // =====================================================
    // ADMIN AUTHENTICATION
    // =====================================================

    HttpSession session = request.getSession(false);

    if (session == null
            || !Boolean.TRUE.equals(
                    session.getAttribute("adminLoggedIn"))
            || !"ADMIN".equals(
                    session.getAttribute("userRole"))) {

        response.sendRedirect("login.jsp");
        return;
    }


    // =====================================================
    // GET ADMIN ID
    // =====================================================

    Object adminIdObject =
            session.getAttribute("adminId");

    if (adminIdObject == null) {

        response.sendRedirect("login.jsp");
        return;
    }


    // =====================================================
    // GET STUDENT ID
    // =====================================================

    String studentIdParameter =
            request.getParameter("studentId");

    if (studentIdParameter == null
            || studentIdParameter.trim().isEmpty()) {

        response.sendRedirect(
                "admin/manage-students.jsp?error=invalid_student");

        return;
    }


    int studentId;

    try {

        studentId =
                Integer.parseInt(
                        studentIdParameter);

    } catch (NumberFormatException e) {

        response.sendRedirect(
                "admin/manage-students.jsp?error=invalid_student");

        return;
    }


    // =====================================================
    // DELETE STUDENT
    // =====================================================

    String deleteSql =
            "DELETE FROM students WHERE id = ?";

    try (Connection conn =
                 DBConnection.getConnection();
         PreparedStatement ps =
                 conn.prepareStatement(deleteSql)) {

        ps.setInt(1, studentId);

        int rowsDeleted =
                ps.executeUpdate();


        if (rowsDeleted == 1) {

            response.sendRedirect(
                    "admin/manage-students.jsp?deleted=success");

        } else {

            response.sendRedirect(
                    "admin/manage-students.jsp?error=not_found");
        }


    } catch (Exception e) {

        e.printStackTrace();

        response.sendRedirect(
                "admin/manage-students.jsp?error=delete_failed");
    }
}

}
