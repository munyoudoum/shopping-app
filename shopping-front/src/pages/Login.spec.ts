import { fireEvent, render, waitFor } from "@testing-library/vue"
import { describe, expect, it, vi } from "vitest"
import { useToast } from "src/plugins/toast"
import { api } from "src/services"
import type { GenericErrorModel, HttpResponse, LoginResponse } from "src/services/api"
import { createTestRouter, renderOptions } from "src/utils/test/test.utils.ts"
import Login from "./Login.vue"

describe("# Login Page", () => {
  const router = createTestRouter()
  it("should render login form", () => {
    const { getByPlaceholderText, getByRole } = render(
      Login,
      renderOptions({ router }),
    )

    expect(getByPlaceholderText("Username")).toBeInTheDocument()
    expect(getByPlaceholderText("Password")).toBeInTheDocument()
    expect(getByRole("button", { name: "Sign in" })).toBeInTheDocument()
  })

  it("should login successfully with valid credentials", async () => {
    vi.spyOn(api.users, "login").mockResolvedValueOnce({
      data: {
        user: {
          username: "testuser",
          id: 1,
          balance: "1",
        },
        token: "fake_token",
      },
    } as HttpResponse<LoginResponse, GenericErrorModel>)

    const { getByPlaceholderText, getByRole } = render(
      Login,
      renderOptions({ router }),
    )
    const toastSuccessSpy = vi.spyOn(useToast(), "success")

    await fireEvent.update(getByPlaceholderText("Username"), "testuser")
    await fireEvent.update(getByPlaceholderText("Password"), "password123")
    await fireEvent.click(getByRole("button", { name: "Sign in" }))

    expect(api.users.login).toHaveBeenCalledWith({
      user: { username: "testuser", password: "password123" },
    })
    expect(toastSuccessSpy).not.toHaveBeenCalled()
    waitFor(() => expect(toastSuccessSpy).toHaveBeenCalled())

    // Add assertions to check if the user is redirected or if the state is updated
    expect(router.currentRoute.value.path).toBe("/")
  })

  it("should display error message with invalid credentials", async () => {
    vi.spyOn(api.users, "login").mockRejectedValueOnce({
      error: {
        errors: {
          "email or password": ["is invalid"],
        },
      },
    })
    const toastErrorSpy = vi.spyOn(useToast(), "error")
    const { getByPlaceholderText, getByRole } = render(
      Login,
      renderOptions({ router }),
    )

    await fireEvent.update(getByPlaceholderText("Username"), "wronguser")
    await fireEvent.update(getByPlaceholderText("Password"), "wrongpassword")
    await fireEvent.click(getByRole("button", { name: "Sign in" }))

    expect(toastErrorSpy).not.toHaveBeenCalled()
    waitFor(() => expect(toastErrorSpy).toHaveBeenCalled())
  })
})
