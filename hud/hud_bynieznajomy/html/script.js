Speedometer = new ProgressBar.Circle("#SpeedCircle", {
  color: "rgba(235, 235, 235, 1)",
  trailColor: "rgba(255, 235, 235, 0.182)",
  strokeWidth: 6,
  duration: 50,
  trailWidth: 6,
  easing: "easeInOut",
});

  //SendNUIMessage({ type = "updateMode", mode = newModeIndex })

window.addEventListener("message", function (event) {
  let data = event.data;

  if (data.action == "update_hud") {

    oxygen = data.oxygen
    if(oxygen>0)
    document.getElementById("OxygenIndicator").style.background='linear-gradient(rgba(0, 0, 0, 0.658) '+(100-oxygen).toString() +'%,#fcc309 0%, #fcc309 '+ oxygen.toString() +'%)';
    else
    $("#OxygenIndicator").hide();

       // Samochód

       $("#LightIcon2").hide();
       $("#LightIcon3").hide();


      if(data.enginebroken >= 750){
        $("#EngineIcon").hide();
        $("#EngineIcon2").hide();
      }

       if(data.enginebroken < 650)
       {
        $("#EngineIcon").show();
        $("#EngineIcon2").hide();
       }
       if(data.enginebroken < 300)
       {
        $("#EngineIcon").hide();
        $("#EngineIcon2").show();
       }

       if(data.pasyon == true){
       $("#BeltIcon2").show();
       $("#BeltIcon").hide();
      }else{
        $("#BeltIcon2").hide();
        $("#BeltIcon").show();
      }

      if(data.engineon == true){
        $("#AcuIcon").hide();
        $("#AcuIcon2").show();
      }else{
        $("#AcuIcon").show();
        $("#AcuIcon2").hide();
      }

      if(data.doorlock == 4){
       $("#LockIcon").hide();
       $("#LockIcon2").show();
      }
      if(data.doorlock == 1){
        $("#LockIcon").show();
        $("#LockIcon2").hide();
      }

      //Długie
      if(data.b1 == 1 && data.b2 == 1 && data.b3 == 1){
        $("#LightIcon3").show();
        $("#LightIcon2").hide();
        $("#LightIcon1").hide();

      }
      //Krótkie
      if(data.b1 == 1 && data.b2 == 0 && data.b3 == 1){
        $("#LightIcon2").show();
        $("#LightIcon1").hide();
        $("#LightIcon").hide();
      }
      //Krótkie
      if(data.b1 == 1 && data.b2 == 1 && data.b3 == 0){
        $("#LightIcon2").show();
        $("#LightIcon1").hide();
        $("#LightIcon").hide();
      }
      //Światła Off
      if(data.b1 == 1 && data.b2 == 0 && data.b3 == 0){
        $("#LightIcon").show();
        $("#LightIcon1").hide();
        $("#LightIcon2").hide();
      }
  
      document.getElementById("showKierunekaSpan").textContent =data.tekstkierunek1 + '|';
      document.getElementById("showLokalizacjaSpan").textContent =data.lokalizacja1;

  }


  if (data.action == "update_hud1") {

    $("#VoiceIndicator").show();

    healt = data.hp;
    $("#HealthIndicator").show();
    document.getElementById("HealthIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - healt).toString() + '%,#00d4ff 0%, #007991 ' + healt.toString() + '%)';

    armor = data.armor;
    $("#ArmorIndicator").show();
    document.getElementById("ArmorIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - armor).toString() + '%,#00d4ff 0%, #007991 ' + armor.toString() + '%)';
    

    hung = data.hunger
    $("#HungerIndicator").show();
    document.getElementById("HungerIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - hung).toString() + '%,#00d4ff 0%, #007991 ' + hung.toString() + '%)';
 
    thirst = data.thirst
    $("#ThirstIndicator").show();
    document.getElementById("ThirstIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - thirst).toString() + '%,#00d4ff 0%, #007991 ' + thirst.toString() + '%)';

    $("#VoiceIndicator").show();
  }
  
  if (data.action == "update_hud2") {
    $("#VoiceIndicator").fadeOut();
    $("#HealthIndicator").fadeOut();
    $("#HungerIndicator").fadeOut();
    $("#ThirstIndicator").fadeOut();
    $("#ArmorIndicator").fadeOut();
  }

  if (data.action == "update_voice") {

    switch (data.voicelev) {
      case 0:
        data.voicelev = 1;
        voice = 33;
        document.getElementById("VoiceIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - voice).toString() + '%,#00d4ff 0%, #007991 ' + voice.toString() + '%)';
        break;
      case 50:
        data.voicelev = 2;
        voice = 66;
        document.getElementById("VoiceIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - voice).toString() + '%,#00d4ff 0%, #007991 ' + voice.toString() + '%)';
        break;
      case 100:
        data.voicelev = 3;
        voice = 100;
        document.getElementById("VoiceIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - voice).toString() + '%,#00d4ff 0%, #007991 ' + voice.toString() + '%)';
        break;
    }

    if (data.talking == 1) {
      document.getElementById("VoiceIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - voice).toString() + '%,rgba(38, 0, 255, 0.658) 0%, rgba(255, 0, 221, 0.658) ' + voice.toString() + '%)';
    } else {
      document.getElementById("VoiceIndicator").style.background = 'linear-gradient(rgba(0, 0, 0, 0.658) ' + (100 - voice).toString() + '%,#00d4ff 0%, #007991 ' + voice.toString() + '%)';
    }
  }

  // Hide voice if disabled
  if (data.action == "disable_voice") {
    $("#VoiceIndicator").hide();
  }
  
//  Show oxygen if underwater
  if (data.showOxygen == true) {
    $("#OxygenIndicator").show();
  } else if (data.showOxygen == false) {
    $("#OxygenIndicator").hide();
  }

  if (data.speed > 0) {
    $("#SpeedIndicator").text(data.speed);
    let multiplier = data.maxspeed * 0.1;
    let SpeedoLimit = data.maxspeed + multiplier + 10;
    Speedometer.animate(data.speed / SpeedoLimit);
    Speedometer.path.setAttribute("stroke","rgba(8, 255, 100, 0.78)");

    var previousGear = document.querySelector('#vehicle-gear span').innerHTML;
    var currentGear = data.gear;
    if (previousGear != currentGear) { document.querySelector('#vehicle-gear').classList.add('pulse') }
    document.getElementById("gearspan").textContent = data.gear;
    if(data.speed>SpeedoLimit){
      Speedometer.animate(0.999);
      Speedometer.path.setAttribute("stroke","rgba(8, 255, 100, 0.78)");
    }
  } else if (data.speed == 0) {
    $("#SpeedIndicator").text("0");
    Speedometer.path.setAttribute("stroke", "none");
  } 

  if (data.showSpeedo == true) {
    $("#VehicleContainer").fadeIn();
  } else if (data.showSpeedo == false) {
    $("#VehicleContainer").fadeOut();
  }

 

  if (data.showUi == true) {
    $(".container").show();
  } else if (data.showUi == false) {
    $(".container").hide();
  }

  if (data.action == "toggle_hud") {
    $("body").fadeToggle()
  }
});

