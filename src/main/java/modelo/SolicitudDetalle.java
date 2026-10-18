package modelo;

public class SolicitudDetalle {
    private int id;
    private int idSolicitud;
    private String codigoMuestra;
    private String tipoEnsayo;
    private int cantidad;
    private double precioUnitario;
    private double subtotalLinea;

    public SolicitudDetalle() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

    public String getCodigoMuestra() { return codigoMuestra; }
    public void setCodigoMuestra(String codigoMuestra) { this.codigoMuestra = codigoMuestra; }

    public String getTipoEnsayo() { return tipoEnsayo; }
    public void setTipoEnsayo(String tipoEnsayo) { this.tipoEnsayo = tipoEnsayo; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }

    public double getSubtotalLinea() { return subtotalLinea; }
    public void setSubtotalLinea(double subtotalLinea) { this.subtotalLinea = subtotalLinea; }
}