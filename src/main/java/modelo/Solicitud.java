package modelo;

import java.util.ArrayList;
import java.util.List;

public class Solicitud {
    private int id;
    private String codigoSolped;
    private int idCliente;
    private String nombreCliente; // Para mostrar mediante JOIN
    private int idAnalista;
    private String nombreAnalista; // Para mostrar mediante JOIN
    private String tipoComprobante;
    private String fechaEmision;
    private double subtotal;
    private double igv;
    private double total;
    private String estado;
    private List<SolicitudDetalle> detalles = new ArrayList<>();

    public Solicitud() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCodigoSolped() { return codigoSolped; }
    public void setCodigoSolped(String codigoSolped) { this.codigoSolped = codigoSolped; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }

    public int getIdAnalista() { return idAnalista; }
    public void setIdAnalista(int idAnalista) { this.idAnalista = idAnalista; }

    public String getNombreAnalista() { return nombreAnalista; }
    public void setNombreAnalista(String nombreAnalista) { this.nombreAnalista = nombreAnalista; }

    public String getTipoComprobante() { return tipoComprobante; }
    public void setTipoComprobante(String tipoComprobante) { this.tipoComprobante = tipoComprobante; }

    public String getFechaEmision() { return fechaEmision; }
    public void setFechaEmision(String fechaEmision) { this.fechaEmision = fechaEmision; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getIgv() { return igv; }
    public void setIgv(double igv) { this.igv = igv; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public List<SolicitudDetalle> getDetalles() { return detalles; }
    public void setDetalles(List<SolicitudDetalle> detalles) { this.detalles = detalles; }
}
