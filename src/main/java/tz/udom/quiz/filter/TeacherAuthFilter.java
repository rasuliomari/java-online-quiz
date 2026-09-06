package tz.udom.quiz.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/teacher/*")
public class TeacherAuthFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session =
                httpRequest.getSession(false);

        boolean teacherLoggedIn =
                session != null
                && Boolean.TRUE.equals(
                        session.getAttribute("teacherLoggedIn")
                )
                && "TEACHER".equals(
                        session.getAttribute("userRole")
                );

        if (!teacherLoggedIn) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login.jsp?error=teacherLoginRequired"
            );

            return;
        }

        chain.doFilter(request, response);
    }
}