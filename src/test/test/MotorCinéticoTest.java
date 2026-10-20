package test;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import modelo.MotorCinetico;

public class MotorCineticoTest {

    private final double DELTA = 1e-4;

    @Test
    @DisplayName("TC-01: Verificación de constante cinética k de primer orden")
    public void testCalcularConstanteK() {
        double c0 = 2.0;
        double ct = 6.0;
        double tiempo = 10.0;
        // k = ln(6/2) / 10 = ln(3)/10 = 0.109861
        double kEsperado = 0.109861;
        double kObtenido = MotorCinetico.calcularConstanteK(c0, ct, tiempo);
        assertEquals(kEsperado, kObtenido, DELTA, "La constante cinética no coincide con el modelo");
    }

    @Test
    @DisplayName("TC-02: Proyección de tiempo crítico hasta umbral de rancidez (10 meq)")
    public void testPredecirTiempoCritico() {
        double c0 = 2.0;
        double cCritico = 10.0;
        double k = 0.109861;
        // t = ln(10/2) / k = ln(5) / 0.109861 = 1.609438 / 0.109861 = 14.65 días
        double tEsperado = 14.65;
        double tCalculado = MotorCinetico.predecirTiempoCritico(c0, cCritico, k);
        assertEquals(tEsperado, tCalculado, 0.05, "El tiempo crítico difiere del umbral permitido");
    }

    @Test
    @DisplayName("TC-03: Cálculo de Energía de Activación de Arrhenius")
    public void testEnergiaActivacion() {
        double k1 = 0.0866;
        double t1 = 323.15; // 50 °C
        double k2 = 0.3520;
        double t2 = 343.15; // 70 °C
        double eaObtenida = MotorCinetico.calcularEnergiaActivacion(k1, t1, k2, t2);
        assertTrue(eaObtenida > 50000 && eaObtenida < 85000, "Energía de activación fuera de rango lipídico estándar");
    }

    @Test
    @DisplayName("TC-04: Concurrencia y tiempo de cómputo < 200 ms")
    public void testRendimientoCómputo() {
        long inicio = System.currentTimeMillis();
        for (int i = 0; i < 5000; i++) {
            MotorCinetico.calcularConstanteK(1.5 + (i * 0.001), 5.0 + (i * 0.001), 12.0);
        }
        long fin = System.currentTimeMillis();
        assertTrue((fin - inicio) < 200, "El tiempo de ejecución sobrepasa el límite no funcional");
    }
}
