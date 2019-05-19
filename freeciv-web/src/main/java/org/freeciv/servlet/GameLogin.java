/*******************************************************************************
 * Freeciv-web - the web version of Freeciv. http://play.freeciv.org/
 * Copyright (C) 2019 The Freeciv-web project
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/
package org.freeciv.servlet;

import java.io.*;
import java.util.Properties;
import javax.servlet.*;
import javax.servlet.http.*;

import java.sql.*;
import javax.sql.*;
import javax.naming.*;

import org.apache.commons.codec.digest.Crypt;

import org.freeciv.util.Constants;


/**
 * Checks user credentials for a game.
 *
 * URL: /game_login
 */
public class GameLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean has_google_key;

    enum AuthMethod {
        PASSWORD,
        GOOGLE
    }

    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        try {
            Properties prop = new Properties();
            prop.load(getServletContext().getResourceAsStream("/WEB-INF/config.properties"));
            String google_signin_key = prop.getProperty("google-signin-client-key");
            has_google_key = (google_signin_key != null && google_signin_key.trim().length() > 0);
        } catch (IOException e) {
            e.printStackTrace();
            has_google_key = false;
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        Connection conn = null;
        try {
            Context env = (Context) (new InitialContext().lookup(Constants.JNDI_CONNECTION));
            DataSource ds = (DataSource) env.lookup(Constants.JNDI_DDBBCON_MYSQL);
            conn = ds.getConnection();

            AuthMethod method = AuthMethod.PASSWORD;

            if (has_google_key) {
                PreparedStatement psAuth = conn.prepareStatement(
                    "SELECT COUNT(*) FROM servers "
                    + "WHERE port = ? AND TYPE = 'longturn' "
                );
                psAuth.setInt(1, Integer.parseInt(java.net.URLDecoder.decode(
                    request.getParameter("port"), "UTF-8")));
                ResultSet rsAuth = psAuth.executeQuery();
                if (rsAuth.next() && rsAuth.getInt(1) > 0) {
                    method = AuthMethod.GOOGLE;
                }
            }

            switch (method) {
            case PASSWORD:
                PreparedStatement psPassword = conn.prepareStatement(
                    "SELECT secure_hashed_password, activated FROM auth "
                    + "WHERE LOWER(username) = LOWER(?) "
                );
                psPassword.setString(1, java.net.URLDecoder.decode(
                    request.getParameter("username"), "UTF-8"));
                ResultSet rsPassword = psPassword.executeQuery();
                if (!rsPassword.next()) {
                    // Unreserved user, no password needed
                    response.getOutputStream().print("OK");
                    return;
                } else {
                    String password = java.net.URLDecoder.decode(
                        request.getParameter("idtoken"), "UTF-8");
                    do {
                        String stored_password = rsPassword.getString(1);
                        int active = rsPassword.getInt(2);
                        if (active == 1
                            && (stored_password == null
                                || stored_password.equals(Crypt.crypt(password,
                                                        stored_password)))) {
                                 
                            response.getOutputStream().print("OK");
                            return;
                        }
                    } while (rsPassword.next());
                }

                response.getOutputStream().print("Failed");

                break;
            case GOOGLE:
                getServletContext().getRequestDispatcher("/token_signin")
                                   .forward(request, response);
                break;
            }

        } catch (Exception err) {
            response.setHeader("result", "error");
            err.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, Constants.ERRMSG_LOGIN);
        } finally {
            if (conn != null)
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, Constants.ERRMSG_POST);

    }

}
