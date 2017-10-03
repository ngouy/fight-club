arena = {
  id: null,
  player_1: {},
  player_2: {},
  choosePlayerUrl: '/choose_player',
  fightUrl: '/fight/',

  init(params) {
    arena.id = params.id
  },

  fight() {
    arena.request('GET', arena.fightUrl + arena.id, {}, (sucess) => {
      json_response = JSON.parse(sucess.response);
      // null matches are not possible for now
      let winner = null, looser =  null;
      if (json_response.winner == arena.player_1.id) {
        [winner, looser] = ['1', '2'];
      } else {
        [winner, looser] = ['2', '1'];
      }
      $(`.player.player-${winner}`).addClass('winner');
      setTimeout( () => {
          $(`.player.player-${winner}`).removeClass('winner');
      }, 3000);
      $(`.player.player-${looser}`).addClass('looser');
      setTimeout( () => {
          $(`.player.player-${looser}`).removeClass('looser');
      }, 3000);
      $('.logger').removeClass('hidden')
      $('.logger .content')[0].textContent = json_response.log;
    });
  },

  choosePlayer(player, position) {
    arena.request('POST', arena.choosePlayerUrl, {player, position, arena: arena.id}, arena.playerChoosed);
  },

  playerChoosed(sucess) {
    json_response = JSON.parse(sucess.response)
    const players = [1, 2];
    players.forEach(function(player_number) {
      if (json_response[`player_${player_number}`].id && arena[`player_${player_number}`].id !== json_response[`player_${player_number}`].id) {
        arena[`player_${player_number}`].id = json_response[`player_${player_number}`].id;
        arena[`player_${player_number}`].name = json_response[`player_${player_number}`].name;
        $(`.img-container.selected-${player_number}`).each((_, elem) => elem.classList.remove(`selected-${player_number}`,'selected'));
        $(`.img-container.${json_response[`player_${player_number}`].id}`).each((_, elem) => elem.classList.add(`selected-${player_number}`, 'selected'));
        arena.set_player(player_number);
      }
    });
    if (arena.player_1.id && arena.player_2.id) {
      $('#vs').removeClass('disabled');
    }
  },

  set_player(player_number) {
    const img_src = $(`.img-container.selected-${player_number}`).find('img')[0].src;
    const $player_div = $(`.ring .player-${player_number}`);
    $player_div.find('img')[0].src = img_src;
    $player_div.find('h3')[0].textContent = arena[`player_${player_number}`].name;
  },

  request(method, url, variables, callback) {
    var params = "";
    var first = true;
    for (var property in variables) {
      if (variables.hasOwnProperty(property)) {
        var key = property;
        var value = variables[key];
        if (!first) {
          params += '&';
        }
        else {
          first = false;
        }
        params += key;
        params += '=';
        params += value;
      }
    }
    var request = new XMLHttpRequest();
    request.open(method, url, true);
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    if (callback) {
      request.onreadystatechange = function() {
        if (request.readyState !== 4) {
          return;
        }
        callback(request);
      };
    }
    request.send(params);
  },
}