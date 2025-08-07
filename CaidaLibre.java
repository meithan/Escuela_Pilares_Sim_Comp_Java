import java.util.Scanner;

public class CaidaLibre {

    public static void main(String[] args) {
        
        // Entrada de usuario
        Scanner scanner = new Scanner(System.in);
        System.out.print("Ingresa altura inicial (metros): ");
        double altura_inicial = scanner.nextDouble();

        // Simulación

        // Parámetros de simulación
        double g = 9.81;
        double paso_temporal = 0.01;

        // Condiciones iniciales
        double tiempo = 0.0;
        double velocidad = 0.0;
        double altura = altura_inicial;

        System.out.printf("%-12s %-18s %-18s\n", "Tiempo (s)", "Altura (m)", "Velocidad (m/s)");
        System.out.println("----------------------------------------------------");

        // Bucle de simulación
        while (altura > 0) {
            
            // Escribir estado actual
            System.out.printf("%-12.2f %-18.3f %-18.3f\n", tiempo, altura, velocidad);

            // Actualizar valores
            velocidad += g * paso_temporal;
            altura -= velocidad * paso_temporal;
            tiempo += paso_temporal;

        }

        double tiempo_teorico = Math.sqrt(2*altura_inicial/g);
        double velocidad_teorica = Math.sqrt(2*g*altura_inicial);
        System.out.println("Resultads teóricos");
        System.out.printf("Tiempo de caída: %12.2f s\n", tiempo_teorico);
        System.out.printf("Velocidad final: %12.2f m/s\n", velocidad_teorica);


    }
}

