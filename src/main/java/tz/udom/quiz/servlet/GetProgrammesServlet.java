package tz.udom.quiz.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
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
            throws ServletException, IOException {

        response.setContentType(
                "application/json;charset=UTF-8");

        String collegeIdText =
                request.getParameter("collegeId");

        PrintWriter out =
                response.getWriter();

        if (collegeIdText == null) {

            out.print("[]");

            return;
        }


        try {

            int collegeId =
                    Integer.parseInt(collegeIdText);


            String sql =
                    "SELECT id, name " +
                    "FROM programmes " +
                    "WHERE college_id = ? " +
                    "ORDER BY name";


            try (Connection connection =
                         DBConnection.getConnection();

                 PreparedStatement ps =
                         connection.prepareStatement(sql)) {

                ps.setInt(1, collegeId);

                try (ResultSet rs =
                             ps.executeQuery()) {

                    StringBuilder json =
                            new StringBuilder("[");

                    boolean first = true;

                    while (rs.next()) {

                        if (!first) {
                            json.append(",");
                        }

                        json.append("{");

                        json.append("\"id\":")
                                .append(rs.getInt("id"))
                                .append(",");

                        json.append("\"name\":\"")
                                .append(
                                    escapeJson(
                                        rs.getString("name")
                                    )
                                )
                                .append("\"");

                        json.append("}");

                        first = false;
                    }

                    json.append("]");

                    out.print(json);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            out.print("[]");
        }
    }


    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"");
    }
}