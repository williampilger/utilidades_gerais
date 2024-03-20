function exportarEventosAgendaPorCalendarioJSON() {
    var hoje = new Date();
    var seteDias = new Date(hoje.getTime() + (7 * 24 * 60 * 60 * 1000));
    var calendarios = CalendarApp.getAllCalendars();
    var eventosPorCalendario = {};
    
    calendarios.forEach(function(calendario) {
      var eventosTemp = calendario.getEvents(hoje, seteDias);
      if (eventosTemp.length > 0) { // Só adiciona se tiver eventos
        eventosPorCalendario[calendario.getName()] = eventosTemp.map(function(evento) {
          return {
            "titulo": evento.getTitle(),
            "dataInicio": evento.getStartTime().toISOString(),
            "dataFim": evento.getEndTime().toISOString(),
            "descricao": evento.getDescription()
          };
        });
      }
    });
    
    return eventosPorCalendario;
  }
  
  function listarTarefas() {
    var listasDeTarefas = Tasks.Tasklists.list().getItems();
    var tarefasPorLista = {};
    
    listasDeTarefas.forEach(function(lista) {
      var tarefas = Tasks.Tasks.list(lista.getId()).getItems();
      if (tarefas) { // Só adiciona se tiver tarefas
        tarefasPorLista[lista.getTitle()] = tarefas.map(function(tarefa) {
          return {
            "titulo": tarefa.getTitle(),
            "status": tarefa.getStatus(),
            "dataDeConclusao": tarefa.getDue() ? new Date(tarefa.getDue()).toISOString() : 'N/A',
            "descricao": tarefa.getNotes() ? tarefa.getNotes() : 'Sem descrição'
          };
        });
      }
    });
    
    return tarefasPorLista;
  }
  
  function exportarEventosETarefasJSON() {
  
    var dadosCombinados = {
      "Eventos": exportarEventosAgendaPorCalendarioJSON(),
      "Tarefas": listarTarefas()
    };
    
    var conteudoJSON = JSON.stringify(dadosCombinados, null, 2);
    var blob = Utilities.newBlob(conteudoJSON, "application/json", "EventosETarefas.json");
    DriveApp.createFile(blob);
  }
  