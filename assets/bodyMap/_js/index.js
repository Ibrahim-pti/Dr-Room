$(document).ready(function () {
    var image = $('img');
    var selectedItems = []
     $('#selections').html( selectedItems.length>0 ?"<b>Selected body Parts: </b>"+ selectedItems : "<b>Please select a body part</b>" );

    var defaultDipTooltip = '<b><u>Spine</u></b>';

    image.mapster(
    {
         fillOpacity: 0.35,
         fillColor: "2E86DE",
         strokeColor: "54A0FF",
         strokeOpacity: 0.9,
         strokeWidth: 3,
         stroke: true,
         isSelectable: true,
         singleSelect: false,
         mapKey: 'name',
         listKey: 'key',
         onClick: function (e) {
             var newToolTip = defaultDipTooltip;
             if($.inArray(e.key,selectedItems) >= 0){
                 selectedItems.splice($.inArray(e.key, selectedItems),1);
             }else{
                 selectedItems.push(e.key);
             }
             if (window.FlutterChannel) {
                 window.FlutterChannel.postMessage(e.key);
             }
             // $('#selections').html( selectedItems.length);
             $('#selections').html( selectedItems.length>0 ?"<b>Selected body Parts: </b>"+ selectedItems.toString().replace(new RegExp('_', 'g')," ").replace(new RegExp(',', 'g'),", ") : "<b>Please select a body part</b>" );

         },
         showToolTip: true,
         toolTipClose: ["tooltip-click", "area-click"],
         areas: [
             {
                // name: "12",
                // key: "12",
                // selected:true,
                // strokeColor: "FFFFFF"
             },
             //    key: "head",
             //    // selected:true,
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "neck",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_shoulder",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_shoulder",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "chest",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "abdominal",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "pelvis",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "hip",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_femur_thigh",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_femur_thigh",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_knee",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_knee",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_tib_fib",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_fib_tib",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_ankle",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_ankle",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_foot",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_foot",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_humerus",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_elbow",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_forearm",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_wrist",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "right_hand",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_hand",
             //    strokeColor: "ABCDEF"
             // },                {
             //    key: "left_wrist",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "left_forearm",
             //    strokeColor: "FFACDF"
             // },                {
             //    key: "left_elbow",
             //    strokeColor: "FFFAAF"
             // },                {
             //    key: "left_humerus",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "skul_brain",
             //    strokeColor: "FFFFFF"
             // },                {
             //    key: "spine",
             //    strokeColor: "FFFFFF"
             // },
             ]

     });

     // Subtle pointer-driven 3D tilt so the diagram feels like a model
     // sitting in space rather than a flat printout.
     var wrap = document.getElementById('bodyImgWrap');
     var maxTilt = 10;
     var resetTimer = null;

     function applyTilt(clientX, clientY) {
         var w = window.innerWidth;
         var h = window.innerHeight;
         var rotateY = ((clientX / w) - 0.5) * maxTilt * 2;
         var rotateX = (0.5 - (clientY / h)) * maxTilt * 2;
         wrap.style.transform = 'rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg)';
     }

     function resetTilt() {
         wrap.style.transform = 'rotateX(0deg) rotateY(0deg)';
     }

     document.addEventListener('pointermove', function (e) {
         clearTimeout(resetTimer);
         applyTilt(e.clientX, e.clientY);
         resetTimer = setTimeout(resetTilt, 1500);
     });

     document.addEventListener('pointerleave', resetTilt);
   });