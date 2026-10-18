package modelo;

public class Cliente implements Cloneable {
    private int id;
    private String rucDni;
    private String razonSocial;
    private String contacto;
    private String email;
    private String telefono;
    private String estado;

    public Cliente() {}

    // Implementación del Patrón Creacional Prototype
    @Override
    public Cliente clone() {
        try {
            return (Cliente) super.clone();
        } catch (CloneNotSupportedException e) {
            Cliente copia = new Cliente();
            copia.setRucDni(this.rucDni);
            copia.setRazonSocial(this.razonSocial);
            copia.setContacto(this.contacto);
            copia.setEmail(this.email);
            copia.setTelefono(this.telefono);
            copia.setEstado(this.estado);
            return copia;
        }
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRucDni() { return rucDni; }
    public void setRucDni(String rucDni) { this.rucDni = rucDni; }

    public String getRazonSocial() { return razonSocial; }
    public void setRazonSocial(String razonSocial) { this.razonSocial = razonSocial; }

    public String getContacto() { return contacto; }
    public void setContacto(String contacto) { this.contacto = contacto; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}