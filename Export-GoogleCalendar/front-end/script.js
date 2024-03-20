$(document).ready(function() {
    // Inicializa o calendário
    $('#calendario').fullCalendar({
        // Adicione as opções do FullCalendar aqui
        events: function(start, end, timezone, callback) {
            $.ajax({
                url: 'EventosETarefas.json', // Atualize para o caminho do seu arquivo JSON
                dataType: 'json',
                success: function(doc) {
                    var eventos = [];
                    // Processa eventos
                    $.each(doc.Eventos, function(calendario, evts) {
                        evts.forEach(function(evt) {
                            eventos.push({
                                title: evt.titulo,
                                start: evt.dataInicio,
                                end: evt.dataFim,
                                description: evt.descricao,
                                color: '#378006' // Cor verde para eventos
                            });
                        });
                    });
                    // Processa tarefas como eventos de dia inteiro
                    $.each(doc.Tarefas, function(lista, tsks) {
                        tsks.forEach(function(tsk) {
                            eventos.push({
                                title: tsk.titulo,
                                start: tsk.dataDeConclusao, // ou outra lógica para data de tarefas
                                allDay: true,
                                description: tsk.descricao,
                                color: '#ff9f89' // Cor diferente para eventos
                            });
                        });
                    });
                    callback(eventos);
                }
            });
        }
    });
});
