value <- false;

printl("script1 is working\n");

function ShowValue(){
	if (value) {
        printl("HIDING!!!\n");
    } else {
        printl("RUNNING!!!\n");
    }
}

function istriggered(){
	value = true;
    ShowValue();
}

function is_not_triggered(){
	value = false;
    ShowValue();
}