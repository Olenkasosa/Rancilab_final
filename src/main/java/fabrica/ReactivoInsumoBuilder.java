package fabrica;

import modelo.ReactivoInsumo;

public class ReactivoInsumoBuilder {
    private final ReactivoInsumo insumo;

    public ReactivoInsumoBuilder() {
        this.insumo = new ReactivoInsumo();
        this.insumo.setEstado("DISPONIBLE");
    }

    public ReactivoInsumoBuilder conCodigo(String codigo) {
        this.insumo.setCodigo(codigo);
        return this;
    }

    public ReactivoInsumoBuilder conNombre(String nombre) {
        this.insumo.setNombre(nombre);
        return this;
    }

    public ReactivoInsumoBuilder conPurezaGrado(String pureza) {
        this.insumo.setPurezaGrado(pureza);
        return this;
    }

    public ReactivoInsumoBuilder conStock(double actual, double minimo, String unidad) {
        this.insumo.setStockActual(actual);
        this.insumo.setStockMinimo(minimo);
        this.insumo.setUnidadMedida(unidad);
        return this;
    }

    public ReactivoInsumoBuilder conProveedor(int idProveedor) {
        this.insumo.setIdProveedor(idProveedor);
        return this;
    }

    public ReactivoInsumoBuilder conVencimiento(String fechaVencimiento) {
        this.insumo.setFechaVencimiento(fechaVencimiento);
        return this;
    }

    public ReactivoInsumo build() {
        return this.insumo;
    }
}
