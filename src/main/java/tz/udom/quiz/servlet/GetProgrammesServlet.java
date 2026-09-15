package tz.udom.quiz.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tz.udom.quiz.util.DBConnection;

@WebServlet("/getProgrammes")
public class GetProgrammesServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String collegeIdText =
                request.getParameter("collegeId");

        if (collegeIdText == null ||
                collegeIdText.trim().isEmpty()) {

            response.getWriter().print("[]");
            return;
        }

        int collegeId;

        try {

            collegeId =
                    Integer.parseInt(collegeIdText);

        } catch (NumberFormatException e) {

            response.getWriter().print("[]");
            return;
        }

        String sql =
                "SELECT id, name "
                        + "FROM programmes "
                        + "WHERE college_id = ? "
                        + "ORDER BY name";

        StringBuilder json =
                new StringBuilder("[");

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, collegeId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                boolean first = true;

                while (resultSet.next()) {

                    if (!first) {
                        json.append(",");
                    }

                    json.append("{");

                    json.append("\"id\":")
                            .append(resultSet.getInt("id"))
                            .append(",");

                    json.append("\"name\":\"")
                            .append(
                                    escapeJson(
                                            resultSet.getString("name")
                                    )
                            )
                            .append("\"");

                    json.append("}");

                    first = false;
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().print("[]");
            return;
        }

        json.append("]");

        response.getWriter().print(json);
    }


    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}