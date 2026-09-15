
package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/deleteCollege")
public class DeleteCollegeServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * Check admin login
         */
        if (session == null ||
                session.getAttribute("adminLoggedIn") == null ||
                !(Boolean) session.getAttribute("adminLoggedIn")) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        /*
         * Get college ID
         */
        String collegeIdText =
                request.getParameter("collegeId");

        if (collegeIdText == null ||
                collegeIdText.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=invalid_college"
            );

            return;
        }

        int collegeId;

        try {

            collegeId =
                    Integer.parseInt(collegeIdText);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=invalid_college"
            );

            return;
        }


        try (Connection connection =
                     DBConnection.getConnection()) {

            /*
             * ==========================================
             * CHECK WHETHER COLLEGE EXISTS
             * ==========================================
             */

            String collegeCheckSql =
                    "SELECT name "
                            + "FROM colleges "
                            + "WHERE id = ?";

            String collegeName = null;

            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    collegeCheckSql
                            )
            ) {

                statement.setInt(1, collegeId);

                try (
                        ResultSet resultSet =
                                statement.executeQuery()
                ) {

                    if (!resultSet.next()) {

                        response.sendRedirect(
                                request.getContextPath()
                                        + "/admin/manage-courses.jsp?error=college_not_found"
                        );

                        return;
                    }

                    collegeName =
                            resultSet.getString("name");
                }
            }


            /*
             * ==========================================
             * CHECK PROGRAMMES
             * ==========================================
             */

            String programmeCheckSql =
                    "SELECT COUNT(*) "
                            + "FROM programmes "
                            + "WHERE college_id = ?";

            int programmeCount = 0;

            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    programmeCheckSql
                            )
            ) {

                statement.setInt(1, collegeId);

                try (
                        ResultSet resultSet =
                                statement.executeQuery()
                ) {

                    if (resultSet.next()) {

                        programmeCount =
                                resultSet.getInt(1);
                    }
                }
            }


            /*
             * ==========================================
             * DELETE COLLEGE
             * ==========================================
             *
             * The database foreign key from programmes
             * to colleges uses ON DELETE CASCADE.
             *
             * Therefore deleting the college also removes
             * its programmes and their dependent courses.
             */

            String deleteSql =
                    "DELETE FROM colleges "
                            + "WHERE id = ?";

            try (
                    PreparedStatement statement =
                            connection.prepareStatement(
                                    deleteSql
                            )
            ) {

                statement.setInt(1, collegeId);

                int rowsDeleted =
                        statement.executeUpdate();

                if (rowsDeleted == 0) {

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/admin/manage-courses.jsp?error=college_not_found"
                    );

                    return;
                }
            }


            /*
             * ==========================================
             * SUCCESS
             * ==========================================
             */

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?success=college_deleted"
            );


        } catch (SQLException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/admin/manage-courses.jsp?error=college_delete_failed"
            );
        }
    }
}

