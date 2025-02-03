# **Create-a-DAO**
**Este contrato permite:**  
  
•	Proponer cambios (ej. transferir fondos, acciones específicas).  
•	Votar propuestas.  
•	Ejecutar propuestas aprobadas.  

  
**Funcionamiento del contrato:**  
  
**1.	Propuestas:**  
•	Los miembros pueden proponer cambios utilizando createProposal.  
•	Cada propuesta tiene un ID único. 

**2.	Votación:**  
•	Los miembros pueden votar una sola vez por propuesta.  
•	Una propuesta es aprobada si alcanza al menos un voto en este ejemplo simple.  
  
**3.	Ejecución:**  
•	Las propuestas aprobadas pueden ejecutarse con executeProposal, transfiriendo los fondos al destinatario especificado.  
  
**4.	Gestión de Fondos:**  
•	El contrato puede recibir ETH mediante receive o fallback.  
•	Solo las propuestas aprobadas pueden transferir fondos fuera del contrato.  
