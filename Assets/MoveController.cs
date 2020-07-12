using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class MoveController : MonoBehaviour
{
    public static MoveController instance;
    private Rigidbody rb;
    public float movementSpeed = 2f, sprintModifier = 1.5f, aimModifier = 0.75f, speedModifier;
    Vector3 movementVector;
    private Transform cam;

    public AudioSource sounds;
    public List<AudioClip> steps = new List<AudioClip>();
    float t = 0;

    public Animator anim;

    bool sprinting;
    bool aiming;

    public Transform gun;
    public Vector3 aimGun, walkGun;

    public event Action OnShoot;

    void Awake()
    {
        instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        cam = transform.GetChild(0).GetChild(0);
    }

    // Update is called once per frame
    void Update()
    {
        anim.ResetTrigger("Shoot");
        aiming = Input.GetMouseButton(1);
        sprinting = !aiming && Input.GetButton("Sprint");
        speedModifier = Input.GetMouseButton(1) ? aimModifier : (Input.GetButton("Sprint") ? sprintModifier : 1);
        movementVector = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
        TranslateMovement(CameraForward(movementVector));

        if (aiming)
            gun.localPosition = aimGun;
        else
            gun.localPosition = walkGun;

        if (movementVector != Vector3.zero)
        {
            anim.SetFloat("IdleWalk", 1f);
            Footsteps();

            if (sprinting)
                anim.SetFloat("WalkSprint", 1f);
            else
                anim.SetFloat("WalkSprint", 0f);

        }
        else
        {
            anim.SetFloat("IdleWalk", 0f);
        }

        anim.SetBool("Aiming", aiming);

        if (Input.GetButtonDown("Fire1"))
        {
            if (OnShoot != null)
                OnShoot.Invoke();
            anim.SetTrigger("Shoot");
        }

    }

    Vector3 CameraForward(Vector3 input)
    {
        Vector3 output = Vector3.zero;
        output += cam.forward * input.z * movementSpeed * speedModifier;
        output += cam.right * input.x * movementSpeed * 0.75f;
        return output;
    }

    public void TranslateMovement(Vector3 input)
    {
        rb.velocity = new Vector3(input.x, rb.velocity.y, input.z);
    }

    public void Footsteps()
    {
        if (t == 0)
        {
            sounds.PlayOneShot(steps[UnityEngine.Random.Range(0, 6)]);
        }
        t += Time.deltaTime;
        float stepDelay = (2 - speedModifier)/2;
        if (t >= stepDelay)
        {
            t = 0;
        }
    }
}
