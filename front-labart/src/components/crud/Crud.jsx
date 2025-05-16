import React, { useState } from "react";
import Dashboard from "./Dashboard";
import DynamicCRUD from "./DynamicCRUD";
import Sidebar from "./Sidebar";

const Crud = () => {
  const [selectedTable, setSelectedTable] = useState(null);
  const [showTables, setShowTables] = useState(false);
  const [key, setKey] = useState(0); // Añade esta línea

  const handleTableSelect = (table) => {
    setSelectedTable(table);
    setKey(prevKey => prevKey + 1); // Forzar remontaje al cambiar de tabla
  };

  return (
    <div style={{ minHeight: '100vh', background: 'linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%)' }}>
      {selectedTable ? (
        <div className="d-flex">
          <Sidebar 
            currentTable={selectedTable} 
            onTableSelect={handleTableSelect} // Usar la nueva función
            showTables={showTables}
            setShowTables={setShowTables}
          />
          <div className="flex-grow-1">
            <DynamicCRUD 
              key={key} // Usar la key para forzar remontaje
              tableName={selectedTable} 
              onBack={() => setSelectedTable(null)}
            />
          </div>
        </div>
      ) : (
        <Dashboard 
          onTableSelect={handleTableSelect} // Usar la nueva función
          showTables={showTables}
          setShowTables={setShowTables}
        />
      )}
    </div>
  );
};

export default Crud;