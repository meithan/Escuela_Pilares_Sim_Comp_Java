public class CaidaLibreConAire {

    public static void main(String[] args) {

        // Simulación

        // Parámetros de simulación
        double altura_inicial = 100.0;
        double masa = 10.0;
        double k = 0.5;
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
            velocidad += (g - (k/masa)*velocidad*velocidad) * paso_temporal;
            altura -= velocidad * paso_temporal;
            tiempo += paso_temporal;

        }

        double vel_terminal = Math.sqrt(masa*g/k);
        System.out.printf("Velocidad terminal esperada: %6.2f m/s\n", vel_terminal);


    }
}

