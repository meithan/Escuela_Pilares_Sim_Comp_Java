import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class CaidaLibreConAireIO {

    public static void main(String[] args) {
        
        // Parámetros de simulación
        double altura_inicial = 100.0;
        double masa = 10.0;
        double k = 0.5;
        double g = 9.81;
        double paso_temporal = 0.01;

        // Archivo para salida de datos
        String archivo = "simulacion.txt";

        // Condiciones iniciales
        double tiempo = 0.0;
        double velocidad = 0.0;
        double altura = altura_inicial;

        System.out.printf("%-12s %-18s %-18s\n", "Tiempo (s)", "Velocidad (m/s)", "Altura (m)");
        System.out.println("----------------------------------------------------");

        try (PrintWriter writer = new PrintWriter(new FileWriter(archivo))) {

            writer.printf("# %-12s %-18s %-18s\n", "Tiempo", "Altura", "Velocidad");

            // Bucle de simulación
            while (altura > 0) {
                
                // Escribir estado actual a pantalla
                System.out.printf("%-12.2f %-18.3f %-18.3f\n", tiempo, velocidad, altura);

                // Escribir estado a disco
                writer.printf("  %-12.2f %-18.3f %-18.3f\n", tiempo, altura, velocidad);

                // Actualizar valores
                velocidad += (g - (k/masa)*velocidad*velocidad) * paso_temporal;
                altura -= velocidad * paso_temporal;
                tiempo += paso_temporal;

            }

        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }            

        double vel_terminal = Math.sqrt(2*altura_inicial/g);
        System.out.printf("Velocidad terminal esperada: %12.2f m/s\n", vel_terminal);


    }
}

