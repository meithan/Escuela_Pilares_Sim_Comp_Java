import java.util.ArrayList;
import java.util.Random;

public class BirthdayParadox {

    // Hace una simulación de un grupo de personas
    // y checa si se repiten dos cumpleaños
    public static boolean simula_grupo(int num_personas) {
        
        Random random = new Random();
        int cumples[] = new int[num_personas];

        // Generamos al azar los cumpleaños de las personas
        for (int i = 0; i < num_personas; i++) {
            int nuevo_cumple = random.nextInt(365);
            cumples[i] = nuevo_cumple;
        }

        // Checamos si hay al menos una repetición
        for (int i = 0; i < num_personas; i++) {
            for (int j = i+1; j < num_personas; j++) {
                if (cumples[i] == cumples[j]) {
                    return true;
                }
            }
        }
        // Si llegamos aquí es que todos son diferentes
        return false;

    }

    // Programa principal
    public static void main(String[] args) {

        // Parámetros del problema y de la simulación  
        int num_personas = 30;
        int num_simulaciones = 10000;

        // Hacemos num_simulaciones y contamos en cuántas hay repetición
        int conteo_cumples = 0;
        for (int i = 0; i < num_simulaciones; i++) {
            
            // Simulación individual
            boolean se_repite = simula_grupo(num_personas);
            if (se_repite) {
                conteo_cumples += 1;
            }

        }

        double prob = (double) conteo_cumples / num_simulaciones * 100;
        System.out.printf("De %d simulaciones de %d personas, en el %.2f%% se repitieron cumpleaños.%n", num_simulaciones, num_personas, prob);
    }
}