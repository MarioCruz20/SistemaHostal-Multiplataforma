package tools;

import java.sql.Date;

/**
 * Utilidades para parsing y validación de datos
 */
public class ParseUtils {
    
    /**
     * Convierte un String a Integer de forma segura
     * @param s String a convertir
     * @return Integer o null si no se puede convertir
     */
    public static Integer parseInt(String s) {
        if (s == null || s.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.valueOf(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    /**
     * Convierte un String a Integer con valor por defecto
     * @param s String a convertir
     * @param defaultValue Valor por defecto si falla
     * @return Integer
     */
    public static int parseInt(String s, int defaultValue) {
        Integer result = parseInt(s);
        return result != null ? result : defaultValue;
    }
    
    /**
     * Convierte un String a Date de forma segura
     * @param s String en formato yyyy-MM-dd
     * @return Date o null si no se puede convertir
     */
    public static Date parseDate(String s) {
        if (s == null || s.trim().isEmpty()) {
            return null;
        }
        try {
            return Date.valueOf(s.trim());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
    
    /**
     * Convierte un String a Double de forma segura
     * @param s String a convertir
     * @return Double o null si no se puede convertir
     */
    public static Double parseDouble(String s) {
        if (s == null || s.trim().isEmpty()) {
            return null;
        }
        try {
            return Double.valueOf(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    /**
     * Convierte un String a Double con valor por defecto
     * @param s String a convertir
     * @param defaultValue Valor por defecto si falla
     * @return Double
     */
    public static double parseDouble(String s, double defaultValue) {
        Double result = parseDouble(s);
        return result != null ? result : defaultValue;
    }
    
    /**
     * Valida que una fecha de entrada sea anterior a la fecha de salida
     * @param fechaEntrada Fecha de entrada
     * @param fechaSalida Fecha de salida
     * @return true si es válido, false si no
     */
    public static boolean validarRangoFechas(Date fechaEntrada, Date fechaSalida) {
        if (fechaEntrada == null || fechaSalida == null) {
            return false;
        }
        return fechaEntrada.before(fechaSalida);
    }
    
    /**
     * Valida que un número esté en un rango
     * @param valor Valor a validar
     * @param min Valor mínimo
     * @param max Valor máximo
     * @return true si está en el rango
     */
    public static boolean validarRango(int valor, int min, int max) {
        return valor >= min && valor <= max;
    }
    
    /**
     * Valida que un número sea positivo
     * @param valor Valor a validar
     * @return true si es positivo o cero
     */
    public static boolean validarPositivo(double valor) {
        return valor >= 0;
    }
}


