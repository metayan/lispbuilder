
(in-package #:lispbuilder-sdl)

(defclass rwops (foreign-object) ()
  (:default-initargs
   :gc t
   :free #'(lambda (fp)
             (when (is-valid-ptr fp)
               ;;(format t "SDL-Free-RW: ~A~%" fp)
               (sdl-cffi::SDL-Free-RW fp)))
   ;;   :free #'sdl-cffi::SDL-Free-RW
   ;;:free
   ;;#'(lambda (fp)
   ;;          (when (is-valid-ptr fp)
   ;;            (cffi:foreign-funcall-pointer (cffi:foreign-slot-value fp 'sdl-cffi::sdl-rwops 'sdl-cffi::close) ()
   ;;                                          :pointer fp :int)))
   )
  (:documentation "A wrapper around a foreign SDL_RWops object.
Free using [FREE](#free)."))

(defun create-RWops-from-file (filename)
  "Creates and returns a new `RWOPS` object from the file at location `FILENAME`."
  (let ((rwops (sdl-base::create-RWops-from-file (namestring filename))))
    (when (sdl-base::is-valid-ptr rwops)
      (make-instance 'rwops :fp rwops))))

(defun create-RWops-from-byte-array (array)
  "Creates and returns a new `RWOPS` object from the Lisp array `ARRAY`."
  (let ((mem-array (cffi:foreign-alloc :unsigned-char :initial-contents array)))
    (make-instance 'rwops :fp (sdl-cffi::sdl-rw-from-mem mem-array (length array)))))

(defun file-to-byte-sequence (filepath)
  "Load a file into an Array of unsigned-byte 8"
  (with-open-file (str filepath :element-type '(unsigned-byte 8))
    (let* ((length (file-length str))
	   (content (make-array (list length)
				:element-type '(unsigned-byte 8)
				:adjustable nil)))
      (read-sequence content str)
      content)))

;; (defmethod load-image-from-byte-sequence (array)
;;   (cffi:with-foreign-object (mem-array :unsigned-char (length array))
;;     (loop for i from 0 below (length array) do
;; 	 (setf (cffi:mem-aref mem-array :unsigned-char i) (aref array i)))
;;     (make-instance 'surface :surface (sdl-cffi::sdl-load-bmp-rw (sdl-cffi::sdl-rw-from-mem mem-array (length array)) 1))))

;; (sdl:with-init ()
;;   (sdl:window 400 400)
;;   (sdl:draw-surface (load-image-from-byte-sequence
;; 		     (file-to-byte-sequence "/home/bin/central-registry/lispbuilder-sdl/examples/lisp.bmp")))
;;   (sdl:update-display)
;;   (sdl:with-events ()
;;     (:quit-event () t)
;;     (:video-expose-event (sdl:update-display))))

;; (sdl:with-init ()
;;   (sdl:window 400 400)
;;   (sdl:draw-surface (load-image (file-to-byte-sequence "/home/bin/central-registry/lispbuilder-sdl/examples/lisp.bmp")
;; 				:key-color-at #(0 0)))
;;   (sdl:update-display)
;;   (sdl:with-events ()
;;     (:quit-event () t)
;;     (:video-expose-event (sdl:update-display))))

