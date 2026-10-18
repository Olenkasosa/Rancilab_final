package servicio;

public interface CalculoComprobanteStrategy {
    double calcularIgv(double subtotal);
    double calcularTotal(double subtotal);
}

// Estrategia para Factura (Desglose formal 18% IGV)
class FacturaStrategy implements CalculoComprobanteStrategy {
    @Override
    public double calcularIgv(double subtotal) {
        return subtotal * 0.18;
    }

    @Override
    public double calcularTotal(double subtotal) {
        return subtotal + calcularIgv(subtotal);
    }
}

// Estrategia para Boleta
class BoletaStrategy implements CalculoComprobanteStrategy {
    @Override
    public double calcularIgv(double subtotal) {
        return subtotal * 0.18;
    }

    @Override
    public double calcularTotal(double subtotal) {
        return subtotal * 1.18;
    }
}