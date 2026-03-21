/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import misClases.ConexionBD;
import model.Usuario;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * NOTA: A partir de esta versión, la contraseña se guarda en texto plano dentro
 * de la columna PasswordHash. NO se usa ningún hash.
 */
public class UsuarioDAO {

    // ================== LOGIN / BÚSQUEDA ==================
    public Usuario buscarPorUsuario(String username) {
        String sql
                = "SELECT U.Id, U.Usuario, U.PasswordHash, U.EmpleadoId, U.Estado, R.Nombre AS RolNombre "
                + "FROM Usuarios U "
                + "INNER JOIN Roles R ON R.Id = U.RolId "
                + "WHERE U.Usuario = ? AND U.Estado = 1";

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("Id"));
                    u.setUsuario(rs.getString("Usuario"));
                    u.setPasswordHash(rs.getString("PasswordHash")); // aquí va la contraseña tal cual
                    u.setEmpleadoId((Integer) rs.getObject("EmpleadoId"));
                    u.setEstado(rs.getBoolean("Estado"));
                    u.setRolNombre(rs.getString("RolNombre"));
                    return u;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /**
     * Devuelve el Usuario si las credenciales son correctas; si no, null.
     * Comparación DIRECTA de texto plano (sin hash).
     */
    public Usuario login(String username, String plainPassword) {
        Usuario u = buscarPorUsuario(username);
        if (u == null) {
            System.out.println("LOGIN: usuario no encontrado o inactivo: " + username);
            return null;
        }

        String passBD = u.getPasswordHash(); // ahora es texto plano
        boolean ok = plainPassword != null && plainPassword.equals(passBD);
        System.out.println("LOGIN: compara plainPassword='" + plainPassword
                + "' con BD='" + passBD + "' => " + ok);

        if (ok) {
            return u;
        }
        return null;
    }

    // ================== CRUD DE USUARIOS ==================
    public List<Usuario> listar(String q) {
        List<Usuario> list = new ArrayList<>();
        String sql
                = "SELECT U.Id, U.Usuario, U.EmpleadoId, U.RolId, U.Estado, "
                + "       R.Nombre AS RolNombre, E.Nombre AS EmpleadoNombre "
                + "FROM Usuarios U "
                + "LEFT JOIN Roles R ON R.Id = U.RolId "
                + "LEFT JOIN Empleados E ON E.Id = U.EmpleadoId "
                + "WHERE (? IS NULL OR ? = '' OR U.Usuario LIKE ? OR R.Nombre LIKE ? OR E.Nombre LIKE ?) "
                + "ORDER BY U.Usuario";

        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, q);
            ps.setString(2, q);
            String like = (q == null || q.isEmpty()) ? null : "%" + q + "%";
            ps.setString(3, like);
            ps.setString(4, like);
            ps.setString(5, like);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("Id"));
                    u.setUsuario(rs.getString("Usuario"));
                    u.setEmpleadoId((Integer) rs.getObject("EmpleadoId"));
                    u.setRolId((Integer) rs.getObject("RolId"));
                    u.setEstado(rs.getBoolean("Estado"));
                    u.setRolNombre(rs.getString("RolNombre"));
                    u.setEmpleadoNombre(rs.getString("EmpleadoNombre"));
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean crear(Usuario u, String plainPassword) {
        String sql = "INSERT INTO Usuarios (Usuario, PasswordHash, RolId, EmpleadoId, Estado) VALUES (?,?,?,?,?)";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, u.getUsuario());
            // guardamos la contraseña tal cual
            ps.setString(2, plainPassword);
            ps.setObject(3, u.getRolId());
            ps.setObject(4, u.getEmpleadoId());
            ps.setBoolean(5, u.getEstado() == null ? true : u.getEstado());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean actualizar(Usuario u) {
        String sql = "UPDATE Usuarios SET RolId=?, EmpleadoId=?, Estado=? WHERE Id=?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setObject(1, u.getRolId());
            ps.setObject(2, u.getEmpleadoId());
            ps.setBoolean(3, u.getEstado() == null ? true : u.getEstado());
            ps.setInt(4, u.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Reset de contraseña: la guarda en texto plano.
     */
    public boolean resetPassword(int id, String newPlain) {
        String sql = "UPDATE Usuarios SET PasswordHash=? WHERE Id=?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            // sin hash
            ps.setString(1, newPlain);
            ps.setInt(2, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM Usuarios WHERE Id = ?";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================== COMBOS ==================
    public List<Map<String, String>> rolesCombo() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT Id, Nombre FROM Roles ORDER BY Nombre";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("id", String.valueOf(rs.getInt("Id")));
                m.put("text", rs.getString("Nombre"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, String>> empleadosCombo() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT Id, Nombre FROM Empleados WHERE Estado=1 ORDER BY Nombre";
        try (Connection cn = ConexionBD.conectar(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("id", String.valueOf(rs.getInt("Id")));
                m.put("text", rs.getString("Nombre"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
