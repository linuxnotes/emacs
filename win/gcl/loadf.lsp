; loadf.lsp   code to load files on Windows    GSN     17 Sep 2003

; Edit the directory path below for your directory
; Put this file directly into C:\
; When you first start GCL, enter:       (load "C:/loadf.lsp")
; Then you can use loadf to load files:  (loadf "mydir/myfile.lsp")

(defun loadf (filestring)
  (load (concatenate 'string
		     "C:/Users/user/AppData/Roaming/"  ; edit this!
		     filestring)))
