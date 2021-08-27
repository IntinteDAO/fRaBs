(perm-space)

(printy (get_directory "."))
(break)

(setq platform (platform))

; Load up the messages for the language we are using
(setq section upgrade_section)
(load "lisp/english.lsp")


; Get the version this game is using so we can compare it later
(load "lisp/version.lsp")
(setq current clive_version)


(defun slash () 
  (select platform
	  ('WATCOM   "\\")
	  ('UNIX "/")))

(defun remove-slash (path)
  (if (equal (schar path (- (length path) 1)) (schar (slash) 0))
      (concatenate 'string (hack-string 0 (- (length path) 2) path))
   path))


(defun hack-string (x1 x2 st)
  (if (<= x1 x2)
      (cons (schar st x1) (hack-string (+ x1 1) x2 st))
    nil))


(defun append-slash (path)
  (if (equal (schar path (- (length path) 1)) (schar (slash) 0))
      path
    (concatenate 'string path (slash))))


(defun sf (filename) (convert_slashes (concatenate 'string source_dir (slash) filename) (slash)))
(defun tf (filename) (convert_slashes (concatenate 'string target_dir filename) (slash)))



(defun go_there (path)
  (select platform
	  ('WATCOM 
	   (if (and (< 2 (length path)) (eq (schar path 1) #\:))
		       (system (concatenate 'string (list (schar path 0) #\:))))
		   (chdir (remove-slash path)))
	  ('UNIX (chdir path))))


(setq target_dir (get_cwd))

(setq error nil)


(let ((source_dir (append-slash (nice_input enter_old_dir
			 "dir>"
			 (if (equal (platform) 'WATCOM)
			     "c:\\abuse"
			   "~/abuse"))))
      (start_dir (get_cwd)))
  (if (not (dir_exsist (remove-slash source_dir)))
      (print (concatenate 'string dir_not_here source_dir))
    (progn
      (go_there source_dir)
     
      (if (and (load "lisp/version.lsp") (<= clive_version current))
	  (progn
	    (print (concatenate 'string already_updated))
	    (print current)
	    (print clive_version))
	(progn
	  (for i in '("levels/level05.spe"
		      "levels/level06.spe"
		      "levels/level07.spe"
		      "levels/level08.spe"
		      "levels/level09.spe"
		      "levels/level10.spe"
		      "levels/level11.spe"
		      "levels/level12.spe"
		      "levels/level13.spe"
		      "levels/level14.spe"
		      "levels/level15.spe"
		      "levels/level16.spe"
		      "levels/level17.spe"
		      "levels/level18.spe"		      
		      "register/alien.spe"
		      "register/alienb.spe"
		      "register/ant.lsp"
		      "register/boss.spe"
		      "register/english.lsp"
		      "register/flyer.lsp"
		      "register/galien.spe"
		      "register/green2.spe"
		      "register/micron.vcd"
		      "register/people.lsp"
		      "register/powerup.lsp"
		      "register/readme.txt"
		      "register/tiles.lsp"
		      "register/trees.spe"
		      "register/trees2.spe"
		      "register/weapons.lsp") do
		      (if (and (not error) 
			       (not (nice_copy updating
					       (sf i)
					       (tf i)))
			       (setq error T)
			       
			       )))
	  (if (and (not error)
		   (show_yes_no complete_title remove_old_reg yes-key no-key))
	      (print "delete stuff"))


	   )))))


(go_there source_dir)

