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

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

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

        boolean adminLoggedIn =
                session != null
                && Boolean.TRUE.equals(
                        session.getAttribute("adminLoggedIn")
                )
                && "ADMIN".equals(
                        session.getAttribute("userRole")
                );

        if (!adminLoggedIn) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                    + "/login.jsp?error=adminLoginRequired"
            );

            return;
        }

        chain.doFilter(request, response);
    }
}